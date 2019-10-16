if !exists('g:test#haskell#stacktest#file_pattern')
  let g:test#haskell#stacktest#file_pattern = '\v^(.*spec.*)\c\.hs$'
endif

" Returns true if the given file belongs to your test runner
function! test#haskell#stacktest#test_file(file) abort
  return test#haskell#test_file('stacktest', g:test#haskell#stacktest#file_pattern, a:file)
endfunction

" Returns test runner's arguments which will run the current file and/or line
function! test#haskell#stacktest#build_position(type, position) abort
  let filename = fnamemodify(a:position['file'], ':t:r')

  if a:type ==# 'nearest'
    let name = s:nearest_test(a:position)
    let s:module_name = substitute(filename, "Spec", "", "")
    if !empty(name)
      return ["test " . "--test-arguments '-m \"" . name . "\"'"]
    else
      return ["test " . "--test-arguments '-m \"" . s:module_name . "\"'"]
    endif
  elseif a:type ==# 'file'
    let s:module_name = substitute(filename, "Spec", "", "")
    return ["test " . "--test-arguments '-m \"" . s:module_name . "\"'"]
  else
    return ['"test"']
  endif
endfunction

function! test#haskell#stacktest#build_args(args) abort
  return a:args
endfunction

function! test#haskell#stacktest#executable() abort
  return 'stack'
endfunction

function! s:nearest_test(position) abort
  let name = test#base#nearest_test(a:position, g:test#haskell#patterns)
  return escape(escape(join(name['test'], ""), '"'), "'")
endfunction
