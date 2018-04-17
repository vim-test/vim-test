function! test#generic#projectionist#test_file(file) abort
  let file = fnamemodify(a:file, ":p")
  for [root, value] in projectionist#query('runner', { "file": l:file })
    let s:last_file = l:file
    return 1
  endfor

  return 0
endfunction

function! test#generic#projectionist#build_position(type, position) abort
  if a:type ==# 'nearest'
    return [a:position['file'].':'.a:position['line']]
  elseif a:type ==# 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#generic#projectionist#build_args(args) abort
  return a:args
endfunction

function! test#generic#projectionist#executable() abort
  for [root, value] in projectionist#query('runner', { "file": s:last_file })
    return value
  endfor
endfunction
