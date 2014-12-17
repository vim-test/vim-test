function! test#jasmine#test_file(file) abort
  return a:file =~? '\v^spec/.*spec\.(js|coffee)$'
endfunction

function! test#jasmine#build_position(type, position) abort
  if a:type == 'nearest' || a:type == 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#jasmine#build_args(args) abort
  let args = a:args

  if empty(filter(copy(a:args), 'test#file_exists(v:val)'))
    let args = args + ['spec/']
  endif
  if !empty(glob('spec/**/*.coffee'))
    let args = ['--coffee'] + args
  endif

  return args
endfunction

function! test#jasmine#executable() abort
  if filereadable('node_modules/.bin/jasmine-node')
    return 'node_modules/.bin/jasmine-node'
  else
    return 'jasmine-node'
  endif
endfunction
