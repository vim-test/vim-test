if !exists('g:test#robot#robot#file_pattern')
  let g:test#robot#robot = '\v^.*\.robot$'
endif

function! test#robot#robot#test_file(file) abort
  return a:file =~# g:test#robot#robot#file_pattern
endfunction

function! test#robot#robot#build_position(type, position) abort
  if a:type ==# 'nearest'
    return [a:position['file']]
  elseif a:type ==# 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#robot#robot#build_args(args, color) abort
  let args = a:args

  return args
endfunction

function! test#robot#robot#executable() abort
  return "python3 -m robot"
endfunction
