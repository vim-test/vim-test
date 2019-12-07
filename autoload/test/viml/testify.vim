if !exists('g:test#viml#testify#file_pattern')
  let g:test#viml#testify#file_pattern = '\.vim$'
endif

function! test#viml#testify#test_file(file) abort
  return a:file =~# g:test#viml#testify#file_pattern
endfunction

function! test#viml#testify#build_position(type, position) abort
  if a:type ==# 'nearest'
    return [':TestifyNearest']
  elseif a:type ==# 'file'
    return [':TestifyFile']
  endif
  return [':TestifySuite']
endfunction

function! test#viml#testify#build_args(args) abort
  return a:args
endfunction

function! test#viml#testify#executable() abort
endfunction
