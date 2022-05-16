if !exists('g:test#scala#sbttest#file_pattern')
  let g:test#scala#sbttest#file_pattern = '\v^(.*test.*|.*suite.*|.*spec.*)\c\.scala$'
endif

" Returns true if the given file belongs to your test runner
function! test#scala#sbttest#test_file(file) abort
  return test#scala#test_file('sbttest', g:test#scala#sbttest#file_pattern, a:file)
endfunction

" Returns test runner's arguments which will run the current file and/or line
function! test#scala#sbttest#build_position(type, position) abort
  let filename = fnamemodify(a:position['file'], ':t:r')

  if a:type ==# 'nearest'
    let name = s:nearest_test(a:position)
    if !empty(name)
      return ['"testOnly *' . filename .' -- -z \"' . name . '\""']
    else
      return ['"testOnly *' . filename . '"']
    endif
  elseif a:type ==# 'file'
    return ['"testOnly *' . filename . '"']
  else
    return ['"test"']
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
  let name_without_doublequotes = substitute(join(name['test'], ""), '"', '', 'g')
  return escape(name_without_doublequotes, "'")
endfunction
