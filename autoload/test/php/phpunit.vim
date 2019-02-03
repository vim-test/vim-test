if !exists('g:test#php#phpunit#file_pattern')
  let g:test#php#phpunit#file_pattern = '\v(t|T)est\.php$'
endif

if !exists('g:test#php#phpunit#test_patterns')
  let g:test#php#phpunit#test_patterns = {
    \ 'test': [
      \ '\v^\s*public function (test\w+)\(',
      \ '\v^\s*\*\s*(\@test)'
    \],
    \ 'namespace': [],
  \}
endif

function! test#php#phpunit#test_file(file) abort
  return a:file =~# g:test#php#phpunit#file_pattern
endfunction

function! test#php#phpunit#build_position(type, position) abort
  if a:type ==# 'nearest'
    let name = s:nearest_test(a:position)
    if !empty(name) | let name = '--filter '.shellescape('::'.name, 1) | endif
    return [name, a:position['file']]
  elseif a:type ==# 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#php#phpunit#build_args(args) abort
  let args = a:args

  if !test#base#no_colors()
    let args = ['--colors'] + args
  endif

  return args
endfunction

function! test#php#phpunit#executable() abort
  if filereadable('./vendor/bin/phpunit')
    return './vendor/bin/phpunit'
  elseif filereadable('./bin/phpunit')
    return './bin/phpunit'
  else
    return 'phpunit'
  endif
endfunction

function! s:nearest_test(position) abort
  " Search backward for the first public method starting with 'test' or the first '@test'
  let name = test#base#nearest_test(a:position, g:test#php#phpunit#test_patterns)

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
