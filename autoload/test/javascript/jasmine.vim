if !exists('g:test#javascript#jasmine#file_pattern')
  let g:test#javascript#jasmine#file_pattern = '\v^spec/.*spec\.(js|jsx|coffee)$'
endif

function! test#javascript#jasmine#test_file(file) abort
  return a:file =~? g:test#javascript#jasmine#file_pattern
endfunction

function! test#javascript#jasmine#build_position(type, position) abort
  if a:type == 'nearest' || a:type == 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#javascript#jasmine#build_args(args) abort
  let args = a:args

  if empty(filter(copy(a:args), 'test#base#file_exists(v:val)'))
    let args = args + ['spec/']
  endif

  if test#base#no_colors()
    let args = ['--noColor'] + args
  endif

  return args
endfunction

function! test#javascript#jasmine#executable() abort
  if filereadable('node_modules/.bin/jasmine-node')
    return 'node_modules/.bin/jasmine-node'
  else
    return 'jasmine-node'
  endif
endfunction
