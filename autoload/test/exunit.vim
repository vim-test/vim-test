function! test#exunit#test_file(file) abort
  return a:file =~# '_test\.exs$'
endfunction

function! test#exunit#build_position(type, position) abort
  if a:type == 'nearest'
    return [a:position['file'].':'.a:position['line']]
  elseif a:type == 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#exunit#build_args(args) abort
  return a:args
endfunction

function! test#exunit#executable() abort
  return 'mix test'
endfunction
