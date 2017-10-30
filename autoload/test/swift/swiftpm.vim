if !exists('g:test#swift#swiftpm#file_pattern')
  let g:test#swift#swiftpm#file_pattern = '\v^Tests\/.*\.swift$'
endif

function! test#swift#swiftpm#test_file(file) abort
  return a:file =~# g:test#swift#swiftpm#file_pattern
endfunction

function! test#swift#swiftpm#build_position(type, position) abort
  if a:type ==# 'nearest'
    let l:module = s:parse_module_info(a:position)
    let l:testcase = s:parse_case_info(a:position)
    let l:nearest = s:parse_nearest_test_info(a:position)
    return ['--specifier', l:module . '.' . l:testcase . '/' . l:nearest]
  elseif a:type ==# 'file'
    let l:module = s:parse_module_info(a:position)
    let l:testcase = s:parse_case_info(a:position)
    return ['--specifier', l:module . '.' . l:testcase]
  else
    return []
  endif
endfunction

function! test#swift#swiftpm#build_args(args) abort
  return a:args
endfunction

function! test#swift#swiftpm#executable() abort
  return 'swift test'
endfunction

function! s:parse_module_info(position) abort
  return s:get_first_match(a:position['file'], g:test#swift#patterns['module'])
endfunction

function! s:parse_case_info(position) abort
  let l:result = ''

  for l:line in getbufline(a:position['file'], 1, '$')
    let l:match = s:get_first_match(l:line, g:test#swift#patterns['namespace'])
    if strlen(l:match) > 0
      let l:result = l:match
      break
    endif
  endfor

  return l:result
endfunction

function! s:parse_nearest_test_info(position) abort
  let l:info = test#base#nearest_test(a:position, g:test#swift#patterns)
  return join(l:info['test'])
endfunction

function! s:get_first_match(source, patterns) abort
  let l:result = ''

  for l:pattern in a:patterns
    let l:matches = matchlist(a:source, pattern)
    if len(l:matches) > 1
      let l:result = l:matches[1]
      break
    endif
  endfor

  return l:result
endfunction
