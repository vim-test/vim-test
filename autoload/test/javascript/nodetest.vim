if !exists('g:test#javascript#nodetest#file_pattern')
  let g:test#javascript#nodetest#file_pattern = '\v(tests?/.*|\.(spec|test))\.js$'
endif

function! test#javascript#nodetest#test_file(file) abort
  if a:file =~# g:test#javascript#nodetest#file_pattern
    return test#javascript#has_import(a:file, 'node:test')
  endif
endfunction

function! test#javascript#nodetest#build_position(type, position) abort
  if a:type ==# 'nearest'
    return ['--test',a:position['file']]
  elseif a:type ==# 'file'
    return ['--test',a:position['file']]
  else
    return []
  endif
endfunction

function! test#javascript#nodetest#build_args(args) abort
  let args = a:args

  return args
endfunction

function! test#javascript#nodetest#executable() abort
  return 'node'
endfunction
