if !exists('g:test#php#pest#file_pattern')
  let g:test#php#pest#file_pattern = '\v(t|T)est\.php$'
endif

if !exists('g:test#php#pest#test_patterns')
  " Description for the tests:
  " https://pestphp.com/docs/writing-tests/
  " 1. Look for a function call that starts with "it" or "test" or "scenario"
  " 2: Look for a public method which name starts with "test"
  " 3: Look for a phpdoc tag "@test" (on a line by itself)
  " 4: Look for a phpdoc block on one line containg the "@test" tag
  " 5: Look for an attribute "#[Test]" or "#[Test," (on a line by itself)
  let g:test#php#pest#test_patterns = {
    \ 'test': [
      \ '\v^\s*%(it|test|scenario)[(]%("|'')(.*)%("|'')',
      \ '\v^\s*public function (test\w+)\(',
      \ '\v^\s*\*\s*(\@test)',
      \ '\v^\s*\/\*\*\s*(\@test)\s*\*\/',
      \ '\v^\s*(#\[\s*Test\s*[,\]])',
    \ ],
    \ 'namespace': [],
  \}
endif

function! test#php#pest#test_file(file) abort
  if a:file =~# g:test#php#pest#file_pattern
    return filereadable('./tests/Pest.php')
  endif
endfunction

function! test#php#pest#build_position(type, position) abort
  if a:type ==# 'nearest'
    let name = s:nearest_test(a:position)
    if !empty(name) | let name = '--filter '.shellescape(name, 1) | endif
    return [name, a:position['file']]
  elseif a:type ==# 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#php#pest#build_args(args, color) abort
  let args = a:args

  if a:color
    let args = ['--colors'] + args
  endif

  return args
endfunction

function! test#php#pest#executable() abort
  if filereadable('./vendor/bin/sail') && (filereadable('./docker-compose.yml') || filereadable('./docker-compose.yaml') || filereadable('./compose.yml') || filereadable('./compose.yaml'))
    return './vendor/bin/sail pest'
  elseif filereadable('./vendor/bin/pest')
    return './vendor/bin/pest'
  elseif filereadable('./bin/pest')
    return './bin/pest'
  else
    return 'pest'
  endif
endfunction

function! s:nearest_test(position) abort
  " Search backward for the first method starting with 'it' or 'test'
  let name = test#base#nearest_test(a:position, g:test#php#pest#test_patterns)

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
