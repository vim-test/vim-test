if !exists('g:test#python#nose2#file_pattern')
  let g:test#python#nose2#file_pattern = '\v(^|[\b_\.-])[Tt]est.*\.py$'
endif

function! test#python#nose2#test_file(file) abort
  if fnamemodify(a:file, ':t') =~# g:test#python#nose2#file_pattern
    if exists('g:test#python#runner')
      return g:test#python#runner ==# 'Nose2'
    else
      return executable('nose2')
    endif
  endif
endfunction

function! test#python#nose2#build_position(type, position) abort
  if a:type ==# 'nearest'
    let name = s:nearest_test(a:position)
    if !empty(name)
      return [s:path_to_module(a:position['file']).'.'.name]
    else
      return [s:path_to_module(a:position['file'])]
    endif
  elseif a:type ==# 'file'
    return [s:path_to_module(a:position['file'])]
  else
    return []
  endif
endfunction

function! test#python#nose2#build_args(args) abort
  return a:args
endfunction

function! test#python#nose2#executable() abort
  return 'nose2'
endfunction

function! s:nearest_test(position) abort
  let name = test#base#nearest_test(a:position, g:test#python#patterns)
  return join(name['namespace'] + name['test'], '.')
endfunction

function! s:path_to_module(str) abort
  return substitute(fnamemodify(a:str, ':r'), '/', '.', 'g')
endfunction
