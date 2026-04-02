if !exists('g:test#ruby#rspec#file_pattern')
  let g:test#ruby#rspec#file_pattern = '\v(_spec\.rb|spec/.*\.feature)$'
endif

function! test#ruby#rspec#test_file(file) abort
  return a:file =~# g:test#ruby#rspec#file_pattern
endfunction

function! test#ruby#rspec#build_position(type, position) abort
  if a:type ==# 'nearest'
    return [a:position['file'].':'.a:position['line']]
  elseif a:type ==# 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#ruby#rspec#build_args(args, color) abort
  let args = a:args

  if !a:color
    let args = ['--no-color'] + args
  endif

  return args
endfunction

function! test#ruby#rspec#executable() abort
  return test#ruby#determine_executable('rspec')
endfunction
