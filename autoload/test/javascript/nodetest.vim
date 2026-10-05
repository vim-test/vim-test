if !exists('g:test#javascript#nodetest#file_pattern')
  let g:test#javascript#nodetest#file_pattern = '\v(tests?/.*|\.(spec|test))\.(js|jsx|ts|tsx)$'
endif

function! test#javascript#nodetest#test_file(file) abort
  if a:file =~# g:test#javascript#nodetest#file_pattern
    return test#javascript#has_import(a:file, 'node:test')
  endif
endfunction

function! test#javascript#nodetest#build_position(type, position) abort
  let base = []

  if test#javascript#has_package('tsx')
    let base = base + ['--import=tsx']
  endif

  if a:type ==# 'nearest'
    let name = s:nearest_test(a:position)
    if !empty(name)
      let name = '--test-name-pattern='.shellescape(name, 1)
    endif
    return base + ['--test', name, a:position['file']]
  elseif a:type ==# 'file'
    return base + ['--test', a:position['file']]
  else
    return base
  endif
endfunction

function! test#javascript#nodetest#build_args(args) abort
  let args = a:args

  return args
endfunction

function! test#javascript#nodetest#executable() abort
  return 'node'
endfunction

function! s:nearest_test(position)
  let name = test#base#nearest_test(a:position, g:test#javascript#patterns)
  return test#base#escape_regex(join(name['namespace'] + name['test']))
endfunction
