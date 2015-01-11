function! test#run(type, options) abort
  if &autowrite || &autowriteall
    silent! wall
  endif

  if test#test_file()
    let position = s:get_position()
  elseif exists("g:test#last_position")
    let position = g:test#last_position
  else
    call test#echo_failure(a:type) | return
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
    call test#echo_failure('last')
  endif
endfunction

function! test#execute(runner, args) abort
  let args = a:args
  let args = [test#base#options(a:runner)] + args
  call filter(args, '!empty(v:val)')

  let executable = test#base#executable(a:runner)
  let args = test#base#build_args(a:runner, args)
  let cmd = [executable] + args
  let compiler = test#base#compiler(a:runner)

  call test#shell(join(cmd), compiler)
endfunction

function! test#shell(cmd, ...) abort
  let strategy = get(g:, 'test#strategy', 'basic')
  call test#strategy#{strategy}(a:cmd, get(a:000, 0))
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

function! test#save_position() abort
  let g:test#last_position = s:get_position()
endfunction

function! s:get_position() abort
  return {
    \ 'file': expand('%:.'),
    \ 'line': line('.'),
    \ 'col':  col('.'),
  \}
endfunction

function! test#echo_failure(type) abort
  echohl WarningMsg
  echo {
    \ 'nearest': 'Unable to find nearest test',
    \ 'file':    'Unable to find test file',
    \ 'suite':   'Unable to determine test runner',
    \ 'last':    'No tests were run so far',
  \}[a:type]
  echohl None
endfunction
