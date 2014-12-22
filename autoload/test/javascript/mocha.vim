function! test#javascript#mocha#test_file(file) abort
  return a:file =~# '\v^tests?/.*\.(js|coffee)$'
endfunction

function! test#javascript#mocha#build_position(type, position) abort
  if a:type == 'nearest'
    let name = s:nearest_test(a:position)
    if !empty(name) | let name = '--grep '.shellescape(name, 1) | endif
    return [a:position['file'], name]
  elseif a:type == 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#javascript#mocha#build_args(args) abort
  let args = a:args

  if !empty(glob('test*/**/*.coffee'))
    let args = ['--compilers coffee:'.s:coffee_compiler()] + args
  endif

  return args
endfunction

function! test#javascript#mocha#executable() abort
  if filereadable('node_modules/.bin/mocha')
    return 'node_modules/.bin/mocha'
  else
    return 'mocha'
  endif
endfunction

function! s:nearest_test(position)
  let name = test#base#nearest_test(a:position, g:test#javascript#levels)
  return join(name[0] + name[1])
endfunction

function! s:coffee_compiler() abort
  if !exists('s:coffee_minor_version')
    if filereadable('node_modules/.bin/coffee')
      let cmd = 'node_modules/.bin/coffee'
    else
      let cmd = 'coffee'
    endif
    let s:coffee_minor_version = matchlist(system(cmd.' -v'), '\v\d+\.(\d+)\.\d+')[1]
  endif

  if s:coffee_minor_version >= 7
    return 'coffee-script/register'
  else
    return 'coffee-script'
  endif
endfunction
