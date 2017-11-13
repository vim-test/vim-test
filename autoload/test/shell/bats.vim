if !exists('g:test#shell#bats#file_pattern')
  let g:test#shell#bats#file_pattern = '\v\.bats$'
endif

function! test#shell#bats#test_file(file) abort
  return a:file =~# g:test#shell#bats#file_pattern
endfunction

function! test#shell#bats#build_position(type, position) abort
  if a:type ==# 'nearest' || a:type ==# 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#shell#bats#build_args(args) abort
  if empty(filter(copy(a:args), 'test#base#file_exists(v:val)'))
    call add(a:args, 'test/')
  endif

  return a:args
endfunction

function! test#shell#bats#executable() abort
  return 'bats'
endfunction
