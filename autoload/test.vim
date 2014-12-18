" ============================================================================
" File:    test.vim
" Author:  Janko Marohnić
" WebPage: https://github.com/janko-m/vim-test
" ============================================================================

function! test#run(type, options) abort
  if test#test_file()
    let position = s:get_position()
  elseif exists("g:test#last_position")
    let position = g:test#last_position
  else
    call test#echo_failure(a:type) | return
  endif

  let runner = test#determine_runner(position['file'])

  let args = test#{runner}#build_position(a:type, position)
  let args = [a:options] + args
  if type(get(g:, 'test#'.runner.'#options')) == type({})
    let args = [get(g:test#{runner}#options, a:type)] + args
  endif

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
  if type(get(g:, 'test#'.a:runner.'#options')) == type('')
    let args = [g:test#{a:runner}#options] + args
  endif
  call filter(args, '!empty(v:val)')

  let executable = get(g:, 'test#'.a:runner.'#executable', test#{a:runner}#executable())
  let args = test#{a:runner}#build_args(args)
  let cmd = [executable] + args
  let compiler = get(g:, 'test#'.a:runner.'#compiler', a:runner)

  call test#shell(join(cmd), compiler)
endfunction

function! test#shell(cmd, ...) abort
  let strategy = get(g:, 'test#strategy', 'basic')
  call test#strategy#{strategy}(a:cmd, get(a:000, 0))
  let g:test#last_command = a:cmd
endfunction

function! test#determine_runner(file) abort
  let file = fnamemodify(a:file, ':.')
  for runner in map(g:test#runners, 'tolower(v:val)')
    if test#{runner}#test_file(file)
      return runner
    endif
  endfor
endfunction

function! test#test_file() abort
  return !empty(test#determine_runner(expand('%')))
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

function! test#file_exists(file) abort
  return !empty(glob(a:file)) || bufexists(a:file)
endfunction
