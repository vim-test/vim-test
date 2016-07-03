function! test#run(type, arguments) abort
  if &autowrite || &autowriteall
    silent! wall
  endif

  if exists('g:test#project_root')
    execute 'cd' g:test#project_root
  end

  if test#test_file()
    let position = s:get_position()
    let g:test#last_position = position
  elseif exists('g:test#last_position')
    let position = g:test#last_position
  else
    call s:echo_failure('Not a test file') | return
  endif

  if type(get(g:, 'test#strategy')) == type({})
    let strategy = g:test#strategy[a:type]
    call add(a:arguments, '-strategy='.strategy)
  endif

  call s:detect_command_strategy(a:arguments)

  let runner = test#determine_runner(position['file'])

  let args = test#base#build_position(runner, a:type, position)
  let args = a:arguments + args
  let args = test#base#options(runner, a:type) + args

  call test#execute(runner, args)

  if exists('g:test#project_root')
    execute 'cd -'
  endif
endfunction

function! test#run_last(arguments) abort
  if exists('g:test#last_command')
    call s:detect_command_strategy(a:arguments)

    let cmd = [g:test#last_command]
    let cmd = cmd + a:arguments

    call test#shell(join(cmd))
  else
    call s:echo_failure('No tests were run so far')
  endif
endfunction

function! test#visit() abort
  if exists('g:test#last_position')
    execute 'edit' '+'.g:test#last_position['line'] g:test#last_position['file']
  else
    call s:echo_failure('No tests were run so far')
  end
endfunction

function! test#execute(runner, args) abort
  let args = a:args
  let args = test#base#options(a:runner) + args
  call filter(args, '!empty(v:val)')

  let executable = test#base#executable(a:runner)
  let args = test#base#build_args(a:runner, args)
  let cmd = [executable] + args
  call filter(cmd, '!empty(v:val)')

  call test#shell(join(cmd))
endfunction

function! test#shell(cmd) abort
  let g:test#last_command = a:cmd
  let cmd = a:cmd

  if has_key(g:, 'test#transformation')
    let cmd = g:test#custom_transformations[g:test#transformation](cmd)
  endif

  if exists('s:strategy')
    let strategy = s:strategy
    unlet s:strategy
  elseif cmd =~# '^:'
    let strategy = 'vimscript'
  else
    let strategy = get(g:, 'test#strategy', 'basic')
  endif

  if has_key(g:test#custom_strategies, strategy)
    call g:test#custom_strategies[strategy](cmd)
  else
    call test#strategy#{strategy}(cmd)
  endif
endfunction

function! test#determine_runner(file) abort
  for [language, runners] in items(g:test#runners)
    for runner in runners
      let runner = tolower(language).'#'.tolower(runner)
      if test#base#test_file(runner, fnamemodify(a:file, ':.'))
        return runner
      endif
    endfor
  endfor
endfunction

function! test#test_file() abort
  return !empty(test#determine_runner(expand('%')))
endfunction

function! s:get_position() abort
  return {
    \ 'file': expand('%'.get(g:, 'test#filename_modifier', ':.')),
    \ 'line': line('.'),
    \ 'col':  col('.'),
  \}
endfunction

function! s:detect_command_strategy(arguments) abort
  for idx in range(0, len(a:arguments) - 1)
    if a:arguments[idx] =~# '^-strategy='
      let s:strategy = substitute(a:arguments[idx], '-strategy=', '', '')
      break
    endif
  endfor
  call filter(a:arguments, 'v:val !~# "^-strategy="')
endfunction

function! s:echo_failure(message) abort
  echohl WarningMsg
  echo a:message
  echohl None
endfunction
