if !exists('g:test#php#pest#file_pattern')
  let g:test#php#pest#file_pattern = '\v(t|T)est\.php$'
endif

if !exists('g:test#php#pest#test_patterns')
  " Description for the tests:
  " https://pestphp.com/docs/writing-tests/
  " Look for a function call that starts with "it" or "test"
  let g:test#php#pest#test_patterns = {
    \ 'test': ['\v^\s*%(it|test)[(]%("|'')(.*)%("|''),'],
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
  if filereadable('./vendor/bin/pest')
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

  return join(name['test'])
endfunction
