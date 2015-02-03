function! test#run(type, options) abort
  if &autowrite || &autowriteall
    silent! wall
  endif

  if test#test_file()
    let position = s:get_position()
    let g:test#last_position = position
  elseif exists('g:test#last_position')
    let position = g:test#last_position
  else
    call s:echo_failure('Not a test file') | return
  endif

  let runner = test#determine_runner(position['file'])

  let args = test#base#build_position(runner, a:type, position)
  let args = [a:options] + args
  let args = [test#base#options(runner, a:type)] + args

  call test#execute(runner, args)
endfunction

function! test#run_last() abort
  if exists('g:test#last_command')
    call test#shell(g:test#last_command)
  else
    call s:echo_failure('No tests were run so far')
  endif
endfunction

function! test#execute(runner, args) abort
  let args = a:args
  let args = [test#base#options(a:runner)] + args
  call filter(args, '!empty(v:val)')

  let executable = test#base#executable(a:runner)
  let args = test#base#build_args(a:runner, args)
  let cmd = [executable] + args
  call filter(cmd, '!empty(v:val)')

  call test#shell(join(cmd))
endfunction

function! test#shell(cmd) abort
  if a:cmd =~# '^:'
    let strategy = 'vimscript'
  else
    let strategy = get(g:, 'test#strategy', 'basic')
  end

  call test#strategy#{strategy}(a:cmd)

  let g:test#last_command = a:cmd
endfunction

function! test#determine_runner(file) abort
  for [language, runners] in items(g:test#runners)
    for runner in runners
      let runner = tolower(language).'#'.tolower(runner)
      if test#base#test_file(runner, a:file)
        return runner
      endif
    endfor
  endfor
endfunction

function! test#test_file() abort
  return !empty(test#determine_runner(expand('%:.')))
endfunction

function! s:get_position() abort
  return {
    \ 'file': expand('%:.'),
    \ 'line': line('.'),
    \ 'col':  col('.'),
  \}
endfunction

function! s:echo_failure(message) abort
  echohl WarningMsg
  echo a:message
  echohl None
endfunction
