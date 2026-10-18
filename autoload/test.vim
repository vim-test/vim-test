function! test#run(type, arguments) abort
  let saved_project_root = get(g:, 'test#project_root', '')
  let had_project_root = exists('g:test#project_root')

  let current_file = fnamemodify(expand('%'), ':p')
  let alternate_file = s:alternate_file()
  if !empty(alternate_file)
    let alternate_file = fnamemodify(alternate_file, ':p')
  endif

  if !had_project_root
    let root = s:detect_project_root(current_file)
    if !empty(root) && root !=# getcwd()
      let g:test#project_root = root
    endif
  endif

  call s:before_run()

  if test#test_file(current_file)
    let position = s:get_position(current_file)
    let g:test#last_position = position
  elseif !empty(alternate_file) && test#test_file(alternate_file) && (!exists('g:test#last_position') || alternate_file !=# g:test#last_position['file'])
    let position = s:get_position(alternate_file)
  elseif exists('g:test#last_position')
    let position = g:test#last_position
  else
    call s:after_run()
    call s:restore_project_root(saved_project_root, had_project_root)
    call s:echo_failure('Not a test file') | return
  endif

  let runner = test#determine_runner(position['file'])

  let args = test#base#build_position(runner, a:type, position)
  let args = a:arguments + args
  let args = test#base#options(runner, args, a:type)

  if type(get(g:, 'test#strategy')) == type({})
    let strategy = get(g:test#strategy, a:type)
    call test#execute(runner, args, strategy)
  else
    call test#execute(runner, args)
  endif

  call s:after_run()
  call s:restore_project_root(saved_project_root, had_project_root)
endfunction

function! test#run_last(arguments) abort
  if exists('g:test#last_command')
    call s:before_run()

    let env = s:extract_env_from_command(a:arguments)
    let strategy = s:extract_strategy_from_command(a:arguments)

    if empty(strategy)
      let strategy = g:test#last_strategy
    endif

    let cmd = [env, g:test#last_command] + a:arguments
    call filter(cmd, '!empty(v:val)')

    call test#shell(join(cmd), strategy)

    call s:after_run()
  else
    call s:echo_failure('No tests were run so far')
  endif
endfunction

function! test#exists() abort
  return test#test_file(expand('%')) || test#test_file(s:alternate_file())
endfunction

function! test#visit() abort
  if exists('g:test#last_position')
    execute 'edit' '+'.g:test#last_position['line'] g:test#last_position['file']
  else
    call s:echo_failure('No tests were run so far')
  endif
endfunction

function! test#execute(runner, args, ...) abort
  let env = s:extract_env_from_command(a:args)
  let strategy = s:extract_strategy_from_command(a:args)
  if empty(strategy)
    if !empty(a:000)
      let strategy = a:1
    else
      let strategy = get(g:, 'test#strategy')
    endif
  endif
  if empty(strategy)
    let strategy = 'basic'
  endif

  let args = a:args
  let args = test#base#options(a:runner, args)
  call filter(args, '!empty(v:val)')

  let executable = test#base#executable(a:runner)
  let args = test#base#build_args(a:runner, args, strategy)
  let cmd = [env, executable] + args
  call filter(cmd, '!empty(v:val)')

  call test#shell(join(cmd), strategy)
endfunction

function! test#shell(cmd, strategy) abort
  let g:test#last_command = a:cmd
  let g:test#last_strategy = a:strategy

  let cmd = a:cmd

  if has_key(g:, 'test#transformation')
    let cmd = g:test#custom_transformations[g:test#transformation](cmd)
  endif

  if cmd =~# '^:'
    let strategy = 'vimscript'
  else
    let strategy = a:strategy
  endif

  if has_key(g:test#custom_strategies, strategy)
    call g:test#custom_strategies[strategy](cmd)
  else
    call test#strategy#{strategy}(cmd)
  endif
endfunction

function! test#determine_runner(file) abort
  for [language, runners] in sort(items(test#get_runners()), 'i')
    for runner in runners
      let runner = tolower(language).'#'.tolower(runner)
      if exists("g:test#enabled_runners")
        if index(g:test#enabled_runners, runner) < 0
          continue
        endif
      endif
      if test#base#test_file(runner, fnamemodify(a:file, ':.'))
        return runner
      endif
    endfor
  endfor
endfunction

function! test#get_runners() abort
  if exists('g:test#runners')
    let custom_runners = g:test#runners
  elseif exists('g:test#custom_runners')
    let custom_runners = g:test#custom_runners
  else
    let custom_runners = {}
  endif

  return s:extend(custom_runners, g:test#default_runners)
endfunction

function! test#test_file(file) abort
  return !empty(test#determine_runner(a:file))
endfunction

function! s:alternate_file() abort
  if get(g:, 'test#no_alternate') | return '' | endif
  let alternate_file = ''

  if empty(alternate_file) && exists('g:loaded_projectionist')
    let alternate_file = get(filter(projectionist#query_file('alternate'), 'filereadable(v:val)'), 0, '')
  endif

  if empty(alternate_file) && has_key(g:, 'test#custom_alternate_file')
    let alternate_file = g:test#custom_alternate_file()
  endif

  if empty(alternate_file) && exists('g:loaded_rails') && !empty(rails#app())
    let alternate_file = rails#buffer().alternate()
  endif

  return alternate_file
endfunction

function! s:before_run() abort
  if &autowrite || &autowriteall
    silent! wall
  elseif get(g:, 'test#prompt_for_unsaved_changes', 0)
    let modified_buffers = len(getbufinfo({'bufmodified': 1}))
    if l:modified_buffers
      let answer = confirm(
            \ "Warning: you have unsaved changes",
            \ "&write\nwrite &all\n&continue", 3)
      if l:answer == 1
        write
      elseif l:answer == 2
        wall
      endif
    endif
  endif

  if exists('g:test#project_root')
    if type(g:test#project_root) == v:t_func
      execute 'cd' g:test#project_root()
    else
      execute 'cd' g:test#project_root
    endif
  endif
endfunction

function! s:after_run() abort
  if exists('g:test#project_root')
    execute 'cd -'
  endif
endfunction

function! s:get_position(path) abort
  let filename_modifier = get(g:, 'test#filename_modifier', ':.')

  let position = {}
  let position['file'] = fnamemodify(a:path, filename_modifier)
  let position['line'] = fnamemodify(a:path, ':p') ==# fnamemodify(expand('%'), ':p') ? line('.') : 1
  let position['col']  = fnamemodify(a:path, ':p') ==# fnamemodify(expand('%'), ':p') ? col('.') : 1

  return position
endfunction

function! s:extract_strategy_from_command(arguments) abort
  for idx in range(0, len(a:arguments) - 1)
    if a:arguments[idx] =~# '^-strategy='
      return substitute(remove(a:arguments, idx), '-strategy=', '', '')
    endif
  endfor
endfunction

function! s:extract_env_from_command(arguments) abort
  let env = filter(copy(a:arguments), 'v:val =~# ''^[A-Z_]\+=.\+''')
  call filter(a:arguments, 'v:val !~# ''^[A-Z_]\+=.\+''')
  return join(env)
endfunction

function! s:echo_failure(message) abort
  echohl WarningMsg
  echo a:message
  echohl None
endfunction

function! s:extend(source, dict) abort
  let result = {}
  for [key, value] in items(a:source)
    let result[key] = value
  endfor
  for [key, value] in items(a:dict)
    let result[key] = get(result, key, []) + value
  endfor
  return result
endfunction

function! s:determine_languages(file) abort
  let languages = []

  for [language, runners] in items(test#get_runners())
    let language_key = tolower(language)
    for runner in runners
      let runner_key = tolower(runner)
      let runner_id = language_key . '#' . runner_key
      " Load the runner file so its file_pattern variable is available.
      call test#base#test_file(runner_id, '')
      let pattern_var = 'g:test#' . runner_id . '#file_pattern'
      if exists(pattern_var)
        let pattern = eval(pattern_var)
        if a:file =~# pattern
          call add(languages, language_key)
          break
        endif
      endif
    endfor
  endfor

  return languages
endfunction

function! s:detect_project_root(file) abort
  let dir = fnamemodify(a:file, ':p:h')
  let languages = s:determine_languages(a:file)
  let markers = []

  for language in languages
    execute 'runtime! autoload/test/' . language . '.vim'
    let markers += get(g:, 'test#' . language . '#root_marker', [])
  endfor

  return s:find_project_root(markers, a:file)
endfunction

function! s:find_project_root(markers, file) abort
  for marker in a:markers
    if filereadable(marker)
      return ''
    endif

    let l:file = findfile(marker, fnamemodify(a:file, ':p:h') . ';' . getcwd())
    if !empty(l:file)
      return fnamemodify(l:file, ':p:h')
    endif
  endfor

  return ''
endfunction

function! s:restore_project_root(saved_project_root, had_project_root) abort
  if a:had_project_root
    let g:test#project_root = a:saved_project_root
  else
    unlet! g:test#project_root
  endif
endfunction
