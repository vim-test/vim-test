function! test#go#gotest#test_file(file) abort
  return a:file =~# '\v[^_].*_test\.go$'
endfunction

function! test#go#gotest#build_position(type, position) abort
  if a:type == 'nearest'
    let name = s:nearest_test(a:position)
    if !empty(name) | let name = '-run '.shellescape(name, 1) | endif
    return [a:position['file'], name]
  elseif a:type == 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#go#gotest#build_args(args) abort
  return a:args
endfunction

function! test#go#gotest#executable() abort
  return "go test"
endfunction

function! s:nearest_test(position) abort
  let name = test#base#nearest_test(a:position, g:test#go#levels)
  return join(name[1])
endfunction
