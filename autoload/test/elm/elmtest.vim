
if !exists('g:test#elm#elmtest#file_pattern')
  let g:test#elm#elmtest#file_pattern = '\vtests?\/.*\.elm$'
endif

function! test#elm#elmtest#test_file(file) abort
  return a:file =~# g:test#elm#elmtest#file_pattern
endfunction

function! test#elm#elmtest#build_position(type, position) abort
  if a:type ==# 'nearest'
    " The test file must be modified to use `only` to only run a single test
    " or group of tests (see
    " https://github.com/elm-community/elm-test#not-running-tests), so just
    " run the file and leave narrowing things down up to the user.
    return [a:position['file']]
  elseif a:type ==# 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#elm#elmtest#build_args(args) abort
  return a:args
endfunction

function! test#elm#elmtest#executable() abort
  return 'elm-test'
endfunction
