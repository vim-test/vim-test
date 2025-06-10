if !exists('g:test#viml#themis#file_pattern')
  let g:test#viml#themis#file_pattern = '\v\.vim(spec)?$'
endif

function! test#viml#themis#test_file(file) abort
  if a:file !~# g:test#viml#themis#file_pattern
    return v:false
  endif
  " themis-style-basic
  if a:file =~# '\.vim$' && !empty(filter(readfile(a:file), 'v:val =~# ''\<themis#suite\s*('''))
    return v:true
  endif
  " themis-style-vimspec
  if a:file =~# '\.vimspec$' && !empty(filter(readfile(a:file), 'v:val =~# ''\v^\s*([Dd]escribe|[Cc]ontext)\s'''))
    return v:true
  endif
  return v:false
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
