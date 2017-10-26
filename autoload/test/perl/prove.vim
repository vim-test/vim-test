if !exists('g:test#perl#prove#file_pattern')
  let g:test#perl#prove#file_pattern = '\v^t/.*\.t$'
endif

function! test#perl#prove#test_file(file) abort
  return a:file =~# g:test#perl#prove#file_pattern
endfunction

function! test#perl#prove#build_position(type, position) abort
  if a:type ==# 'file' || a:type ==# 'nearest'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#perl#prove#build_args(args) abort
  let args = []
  let test_args = []

  for idx in range(0, len(a:args) - 1)
    if a:args[idx] ==# '::' || !empty(test_args) && !test#base#file_exists(a:args[idx])
      call add(test_args, a:args[idx])
    else
      call add(args, a:args[idx])
    endif
  endfor

  let args = args + test_args

  if !empty(filter(copy(args), 'isdirectory(v:val)'))
    let args = ['--recurse'] + args
  endif

  if test#base#no_colors()
    let args = ['--nocolor'] + args
  endif

  return args
endfunction

function! test#perl#prove#executable() abort
  return 'prove -l'
endfunction
