if !exists('g:test#php#paratest#file_pattern')
  " match PHPUnit file pattern as ParaTest simply runs PHPUnit tests in parallel
  let g:test#php#paratest#file_pattern = g:test#php#phpunit#file_pattern
endif

if !exists('g:test#php#paratest#test_patterns')
  " match PHPUnit test patterns as ParaTest simply runs PHPUnit tests in parallel
  let g:test#php#paratest#test_patterns = g:test#php#phpunit#test_patterns
endif

function! test#php#paratest#test_file(file) abort
  return a:file =~# g:test#php#paratest#file_pattern
endfunction

function! test#php#paratest#build_position(type, position) abort
  if a:type ==# 'nearest'
    let name = s:nearest_test(a:position)
    if !empty(name) | let name = '--runner=Runner -f --filter '.shellescape('::'.name, 1) | endif
    return [name, a:position['file']]
  elseif a:type ==# 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#php#paratest#build_args(args) abort
  let args = a:args

  if !test#base#no_colors()
    let args = ['--colors'] + args
  endif

  return args
endfunction

function! test#php#paratest#executable() abort
  if filereadable('./vendor/bin/paratest')
    return './vendor/bin/paratest'
  elseif filereadable('./bin/paratest')
    return './bin/paratest'
  else
    return 'paratest'
  endif
endfunction

function! g:test#php#paratest#enabled_and_available() abort
  if g:test#php#useparatest && executable(test#php#paratest#executable())
    return test#php#paratest#executable()
  else
    return 0
  endif
endfunction

function! s:nearest_test(position) abort
  " Search backward for the first public method starting with 'test' or the first '@test'
  let name = test#base#nearest_test(a:position, g:test#php#paratest#test_patterns)

  " If we found the '@test' docblock
  if !empty(name['test']) && '@test' == name['test'][0]
    " Search forward for the first declared public method
    let name = test#base#nearest_test_in_lines(
      \ a:position['file'],
      \ name['test_line'],
      \ a:position['line'],
      \ g:test#php#patterns
    \ )
  endif

  return join(name['test'])
endfunction
