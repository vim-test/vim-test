if !exists('g:test#python#robot#file_pattern')
  let g:test#python#robot = '\v^.*\.robot$'
endif

function! test#python#robot#test_file(file) abort
  return a:file =~# g:test#python#robot#file_pattern
endfunction

function! test#python#robot#build_position(type, position) abort
  if a:type ==# 'nearest'
    return [a:position['file']]
  elseif a:type ==# 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#python#robot#build_args(args, color) abort
  let args = a:args

  return args
endfunction

function! test#python#robot#executable() abort
  return "python3 -m robot"
endfunction
