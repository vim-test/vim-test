if !exists('g:test#robot#robotframework#file_pattern')
  let g:test#robot#robotframework#file_pattern = '\v^.*\.robot$'
endif

function! test#robot#robotframework#test_file(file) abort
  return a:file =~# g:test#robot#robotframework#file_pattern
endfunction

function! test#robot#robotframework#build_position(type, position) abort
  if a:type ==# 'nearest'
    return [a:position['file']]
  elseif a:type ==# 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#robot#robotframework#build_args(args, color) abort
  let args = a:args

  return args
endfunction

function! test#robot#robotframework#executable() abort
  return "python3 -m robot"
endfunction
