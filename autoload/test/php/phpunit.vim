if !exists('g:test#php#phpunit#file_pattern')
  let g:test#php#phpunit#file_pattern = '\v(t|T)est\.php$'
endif

if !exists('g:test#php#phpunit#test_patterns')
  " Description for the tests:
  " 1: Look for a public method which name starts with "test"
  " 2: Look for a phpdoc tag "@test" (on a line by itself)
  " 3: Look for a phpdoc block on one line containg the "@test" tag
  " 4: Look for an attribute "#[Test]" or "#[Test," (on a line by itself)
  let g:test#php#phpunit#test_patterns = {
    \ 'test': [
      \ '\v^\s*public function (test\w+)\(',
      \ '\v^\s*\*\s*(\@test)',
      \ '\v^\s*\/\*\*\s*(\@test)\s*\*\/',
      \ '\v^\s*(#\[\s*Test\s*[,\]])',
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
    if !empty(name) && test#php#phpunit#executable() =~ 'paratest'
      let name = '--functional '. name
    endif
    return [name, a:position['file']]
  elseif a:type ==# 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#php#phpunit#build_args(args, color) abort
  let args = a:args

  if a:color
    let args = ['--colors'] + args
  endif

  return args
endfunction

function! test#php#phpunit#executable() abort
  if exists('g:test#php#phpunit#executable')
    return g:test#php#phpunit#executable
  elseif filereadable('./vendor/bin/sail') && (filereadable('./docker-compose.yml') || filereadable('./docker-compose.yaml'))
    return './vendor/bin/sail test'
  elseif filereadable('./vendor/bin/paratest')
    return './vendor/bin/paratest'
  elseif filereadable('./vendor/bin/phpunit')
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
  if !empty(name['test']) && ('@test' == name['test'][0] || '#' == name['test'][0][0])
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
