if !exists('g:test#scala#sbttest#file_pattern')
  let g:test#scala#sbttest#file_pattern = '\v^.*.scala$'
endif

" Returns true if the given file belongs to your test runner
function! test#scala#sbttest#test_file(file) abort
  return a:file =~? g:test#scala#sbttest#file_pattern
endfunction

" Returns test runner's arguments which will run the current file and/or line
function! test#scala#sbttest#build_position(type, position) abort
  let filename = fnamemodify(a:position['file'], ':t:r')

  if a:type ==# 'nearest'
    let name = s:nearest_test(a:position)
    if !empty(name)
      return ['"test:test-only *' . filename .' -- -z ' . name . '"']
    else
      return ['"test:test-only *' . filename . '"']
    endif
  elseif a:type ==# 'file'
    return ['"test:test-only *' . filename . '"']
  else
    return []
  endif
endfunction

function! test#scala#sbttest#build_args(args) abort
  return a:args
endfunction

function! test#scala#sbttest#executable() abort
  return 'sbt'
endfunction

function! s:nearest_test(position) abort
  let name = test#base#nearest_test(a:position, g:test#scala#patterns)
  return escape(join(name['test'], ''), '"')
endfunction
