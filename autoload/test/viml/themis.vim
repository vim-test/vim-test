if !exists('g:test#viml#themis#file_pattern')
  let g:test#viml#themis#file_pattern = '\.vim$'
endif

function! test#viml#themis#test_file(file) abort
  return a:file =~# g:test#viml#themis#file_pattern
        \ && !empty(filter(readfile(a:file), 'v:val =~# ''\<themis#suite\s*('''))
endfunction

function! test#viml#themis#build_position(type, position) abort
  if a:type == 'nearest' || a:type == 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#viml#themis#build_args(args) abort
  return a:args
endfunction

function! test#viml#themis#executable() abort
  return 'themis'
endfunction
