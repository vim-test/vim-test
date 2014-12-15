function! test#nose#test_file(file) abort
  return fnamemodify(a:file, ':t') =~# '^test_.*\.py$'
endfunction

function! test#nose#build_position(type, position) abort
  if a:type == 'nearest' || a:type == 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#nose#build_args(args) abort
  return a:args
endfunction

function! test#nose#executable() abort
  return 'nosetests --doctest-tests'
endfunction
