function! test#gotest#test_file(file) abort
  return a:file =~# '\v[^_].*_test\.go$'
endfunction

function! test#gotest#build_position(type, position) abort
  if a:type == 'nearest'
    let name = test#gotest#nearest_test(a:position)
    if !empty(name) | let name = '-run '.shellescape(name, 1) | endif
    return [a:position['file'], name]
  elseif a:type == 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#gotest#build_args(args) abort
  return a:args
endfunction

function! test#gotest#executable() abort
  return "go test"
endfunction

function! test#gotest#nearest_test(position)
  let regex = '\v^\s*func \zs\w+'

  for line in reverse(getbufline(a:position['file'], 1, a:position['line']))
    if !empty(matchstr(line, regex))
      return matchstr(line, regex)
    endif
  endfor
endfunction

