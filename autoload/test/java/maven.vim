if !exists('g:test#java#maven#file_pattern')
  let g:test#java#maven#file_pattern = '\v^.*[Tt]est\.java$'
endif

function! test#java#maven#test_file(file) abort
  return a:file =~? g:test#java#maven#file_pattern
endfunction

function! test#java#maven#build_position(type, position) abort
  if a:type == 'nearest'
    let name = s:nearest_test(a:position)
    if !empty(name)
      return [name]
    else
      return [filename]
    endif
  elseif a:type == 'file'
    let strip_extension = split(a:position['file'], "\.java")[1]
    let filename = split(strip_extension, "/")[-1]
    return [filename]
  else
    return []
  endif
endfunction

function! test#java#maven#build_args(args) abort
  let args = ['-Dtest='] + a:args
  return [join(args, "")]

endfunction

function! test#java#maven#executable() abort
  return 'mvn test'
endfunction

function! s:nearest_test(position) abort
  let name = test#base#nearest_test(a:position, g:test#java#patterns)
  return escape(join(name['namespace'] + name['test'], '#'), "#")
endfunction
