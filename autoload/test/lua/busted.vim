if !exists('g:test#lua#busted#file_pattern')
  let g:test#lua#busted#file_pattern = '\v_spec\.(lua|moon)$'
endif

function! test#lua#busted#test_file(file) abort
  return a:file =~# g:test#lua#busted#file_pattern
endfunction

function! test#lua#busted#build_position(type, position) abort
  if a:type ==# 'nearest'
    let name = s:nearest_test(a:position)
    if !empty(name)
      return [a:position['file'].'::'.name]
    else
      return [a:position['file']]
    endif
  elseif a:type ==# 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#lua#busted#build_args(args) abort
  return a:args
endfunction

function! test#lua#busted#executable() abort
  return 'busted'
endfunction

function! s:nearest_test(position) abort
  let name = test#base#nearest_test(a:position, g:test#lua#patterns)
  let namespace_str = join(name['namespace'], '::')
  let test_id = []

  if !empty(name['namespace'])
      let test_id = test_id + name['namespace']
  endif
  if !empty(name['test'])
      let test_id = test_id + name['test']
  endif

  " ex:
  "   /path/to/file.py::TestClass
  "   /path/to/file.py::TestClass::method
  "   /path/to/file.py::TestClass::NestedClass::method
  let dtest_str = join(test_id, '::')
  return dtest_str
endfunction
