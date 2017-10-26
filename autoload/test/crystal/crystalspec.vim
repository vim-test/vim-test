if !exists('g:test#crystal#crystalspec#file_pattern')
  let g:test#crystal#crystalspec#file_pattern = '\v_spec\.cr$'
endif

function! test#crystal#crystalspec#test_file(file) abort
  return a:file =~# g:test#crystal#crystalspec#file_pattern
endfunction

function! test#crystal#crystalspec#build_position(type, position) abort
  if a:type ==# 'nearest'
    return [a:position['file'].':'.a:position['line']]
  elseif a:type ==# 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#crystal#crystalspec#build_args(args) abort
  return a:args
endfunction

function! test#crystal#crystalspec#executable() abort
  return 'crystal spec'
endfunction
