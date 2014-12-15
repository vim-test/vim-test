function! test#jasmine#test_file(file) abort
  return a:file =~? '\v^spec/.*spec\.(js|coffee|litcoffee)$'
endfunction

function! test#jasmine#build_position(type, position) abort
  if a:type == 'nearest' || a:type == 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#jasmine#build_args(args) abort
  if empty(filter(copy(a:args), 'v:val =~# "spec/"'))
    call add(a:args, 'spec/')
  endif

  return a:args
endfunction

function! test#jasmine#executable() abort
  if !empty(glob('spec*/**/*coffee'))
    return 'jasmine-node --coffee'
  else
    return 'jasmine-node'
  endif
endfunction
