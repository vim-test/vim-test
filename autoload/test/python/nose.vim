if !exists('g:test#python#nose#file_pattern')
  let g:test#python#nose#file_pattern = '\v(^|[\b_\.-])[Tt]est.*\.py$'
endif

function! test#python#nose#test_file(file) abort
  if fnamemodify(a:file, ':t') =~# g:test#python#nose#file_pattern
    if exists('g:test#python#runner')
      return g:test#python#runner ==# 'nose'
    else
      return executable('nosetests')
    endif
  endif
endfunction

function! test#python#nose#build_position(type, position) abort
  if a:type ==# 'nearest'
    let name = s:nearest_test(a:position)
    if !empty(name)
      return [a:position['file'].':'.name]
    else
      return [a:position['file']]
    endif
  elseif a:type ==# 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#python#nose#build_args(args) abort
  return ['--doctest-tests'] + a:args
endfunction

function! test#python#nose#executable() abort
  return 'nosetests'
endfunction

function! s:nearest_test(position) abort
  let name = test#base#nearest_test(a:position, g:test#python#patterns)
  return join(name['namespace'] + name['test'], '.')
endfunction
