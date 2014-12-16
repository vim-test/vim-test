function! test#jasmine#test_file(file) abort
  return a:file =~? '\vspec\.(js|coffee|litcoffee)$'
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
  if !empty(glob('**/*coffee'))
    let args = ['--coffee'] + args
  endif

  return args
endfunction

function! test#jasmine#executable() abort
  return 'jasmine-node'
endfunction
