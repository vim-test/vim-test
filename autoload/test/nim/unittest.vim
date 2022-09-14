if !exists('g:test#nim#unittest#file_pattern')
  let g:test#nim#unittest#file_pattern = '\v\.nim$'
endif

function! test#nim#unittest#test_file(file) abort
  return a:file =~# g:test#nim#unittest#file_pattern
endfunction

function! test#nim#unittest#build_position(type, position) abort
  if a:type ==# 'nearest'
    let name = s:nearest_test(a:position)
    if !empty(name)
      return [a:position['file'] . ' ' . shellescape(name, 1)]
    else
      return [a:position['file']]
    endif
  elseif a:type ==# 'suite'
    let name = s:suite_test(a:position)
    if !empty(name)
      return [a:position['file'] . ' ' . shellescape(name, 1)]
    else
      return [a:position['file']]
    endif
  elseif a:type ==# 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#nim#unittest#build_args(args) abort
  return ['compile', '--run'] + a:args
endfunction

function! test#nim#unittest#executable() abort
  return 'nim'
endfunction

function! s:nearest_test(position) abort
  let name = test#base#nearest_test(a:position, g:test#nim#patterns)

  if !empty(name['test'])
    return name['test'][0]
  endif

  if !empty(name['namespace'])
    return name['namespace'][0] . '::'
  endif

  return ""
endfunction

function! s:suite_test(position) abort
  let name = test#base#nearest_test(a:position, g:test#nim#patterns)

  if !empty(name['namespace'])
    return name['namespace'][0] . '::'
  endif

  return ""
endfunction
