if !exists('g:test#mint#minttest#file_pattern')
  let g:test#mint#minttest#file_pattern = '\v\.mint$'
endif

function! test#mint#minttest#test_file(file) abort
  return a:file =~# g:test#mint#minttest#file_pattern
endfunction

function! test#mint#minttest#build_position(type, position) abort
  if a:type ==# 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#mint#minttest#build_args(args) abort
  return a:args
endfunction

function! test#mint#minttest#executable() abort
  return 'mint test'
endfunction
