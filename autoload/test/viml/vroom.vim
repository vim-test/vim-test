if !exists('g:test#viml#vroom#file_pattern')
  let g:test#viml#vroom#file_pattern = '\v\.vroom$'
endif

function! test#viml#vroom#test_file(file) abort
  return a:file =~# g:test#viml#vroom#file_pattern
endfunction

function! test#viml#vroom#build_position(type, position) abort
  if a:type == 'nearest' || a:type == 'file'
    return [a:position.file]
  elseif a:type == 'suite'
    return ['--crawl', fnamemodify(a:position.file, ':h')]
  endif
endfunction

function! test#viml#vroom#build_args(args) abort
  return a:args
endfunction

function! test#viml#vroom#executable() abort
  return 'vroom'
endfunction
