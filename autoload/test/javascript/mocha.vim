function! test#javascript#mocha#test_file(file) abort
  return a:file =~# '\vtests?/.*\.(js|jsx|coffee)$'
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

  let compilers = []
  if !empty(glob('**/*.coffee'))
    let compilers += ['coffee:'.s:coffee_compiler()]
  endif
  if !empty(glob('**/*.jsx'))
    let compilers += ['jsx:'.s:jsx_compiler()]
  endif

  if !empty(compilers)
    let args = ['--compilers '.join(compilers, ',')] + args
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
  let name = test#base#nearest_test(a:position, g:test#javascript#patterns)
  return join(name['namespace'] + name['test'])
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

function! s:jsx_compiler() abort
  return 'babel-core/register'
endfunction
