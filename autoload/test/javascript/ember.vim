if !exists('g:test#javascript#ember#file_pattern')
  let g:test#javascript#ember#file_pattern = '\v(tests?/.*|(test))\.(js|jsx|ts|tsx|coffee)$'
endi

function! test#javascript#ember#test_file(file) abort
  if a:file =~# g:test#javascript#ember#file_pattern
    if exists('g:test#javascript#runner')
      return g:test#javascript#runner ==# 'ember'
    else
      return test#javascript#has_package('ember-cli')
    endif
  endif
endfunction

function! test#javascript#ember#build_position(type, position) abort
  let args = []

  " keep track of nearest_not_found so we can run TestFile logic if needed
  let nearest_not_found = 0
  if a:type ==# 'nearest'
    let name = s:nearest_test(a:position)
    if !empty(name)
      call add(args, '--filter '.shellescape(name, 1))
    endif

    let module = s:nearest_module(a:position)
    if !empty(module)
      call add(args, '--module '.shellescape(module, 1))
    else
      let nearest_not_found = 1
    endif
  endif

  if nearest_not_found || a:type ==# 'file'
    let modules = s:modules(a:position)
    if !empty(modules)
      call add(args, '--module '.shellescape(modules[0], 1))
    endif
  endif

  return args
endfunction

function! test#javascript#ember#build_args(args, _) abort
  return a:args
endfunction

function! test#javascript#ember#executable() abort
  if filereadable('node_modules/.bin/ember')
    return 'node_modules/.bin/ember exam'
  else
    return 'ember exam'
  endif
endfunction

function! s:nearest_test(position) abort
  let nearest = test#base#nearest_test(a:position, g:test#javascript#patterns)
  return join(nearest['test'])
endfunction

function! s:nearest_module(position) abort
  let nearest = test#base#nearest_test(a:position, g:test#javascript#patterns)
  return join(nearest['namespace'], ' > ')
endfunction

function! s:modules(position) abort
  let a:position['line'] = line('$')
  let first = test#base#nearest_test(a:position, g:test#javascript#patterns)
  return first['namespace']
endfunction
