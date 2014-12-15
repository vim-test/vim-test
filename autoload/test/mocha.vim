function! test#mocha#test_file(file) abort
  return a:file =~# '\v^test/.*\.(js|coffee|litcoffee)$'
endfunction

function! test#mocha#build_position(type, position) abort
  if a:type == 'nearest'
    let name = test#mocha#nearest_test(a:position)
    if !empty(name) | let name = '--grep '.shellescape(name, 1) | endif
    return [a:position['file'], name]
  elseif a:type == 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#mocha#build_args(args) abort
  return a:args
endfunction

function! test#mocha#executable() abort
  if !empty(glob('test*/**/*coffee'))
    return 'mocha --compilers coffee:coffee-script,litcoffee:coffee-script'
  else
    return 'mocha'
  endif
endfunction

function! test#mocha#nearest_test(position)
  for line in reverse(getbufline(a:position['file'], 1, a:position['line']))
    let regex = '\v^\s*%(describe|it)%(\(| )("|'')\zs.+\ze\1'

    if !empty(matchstr(line, regex))
      return matchstr(line, regex)
    endif
  endfor
endfunction
