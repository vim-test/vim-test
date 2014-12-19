function! test#busted#test_file(file) abort
  return a:file =~# '_spec.lua$'
endfunction

function! test#busted#build_position(type, position) abort
  if a:type == 'nearest' || a:type == 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#busted#build_args(args) abort
  return a:args
endfunction

function! test#busted#executable() abort
  return "busted"
endfunction
