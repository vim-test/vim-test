if !exists('g:test#javascript#karma#file_pattern')
  let g:test#javascript#karma#file_pattern = '\v^spec/.*spec\.(js|jsx|coffee)$'
endif

let s:karma_file = expand('<sfile>:p:h', 1) . '/karma-args'

function! test#javascript#karma#test_file(file) abort
  return a:file =~? g:test#javascript#karma#file_pattern
endfunction

function! test#javascript#karma#build_position(type, position) abort
  " There is no easy way to restrict the test files with karma.  Until a way
  " is found to easily accomplish this, we'll get an empty list here
  return []
endfunction

function! test#javascript#karma#build_args(args) abort
  let args = a:args

  if test#base#no_colors()
    let args = ['--no-color'] + args
  endif

  return args
endfunction

function! test#javascript#karma#executable() abort
  return 'node ' . s:karma_file
endfunction

function! s:nearest_test(position)
  let name = test#base#nearest_test(a:position, g:test#javascript#patterns)
  return join(name['namespace'] + name['test'])
endfunction
