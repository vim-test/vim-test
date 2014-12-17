function! test#bats#test_file(file) abort
  return a:file =~# '\.bats$'
endfunction

function! test#bats#build_position(type, position) abort
  if a:type == 'nearest' || a:type == 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#bats#build_args(args) abort
  if empty(filter(copy(a:args), 'test#file_exists(v:val)'))
    call add(a:args, 'test/')
  endif

  return a:args
endfunction

function! test#bats#executable() abort
  return 'bats'
endfunction
