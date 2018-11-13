if !exists('g:test#java#gradletest#file_pattern')
  let g:test#java#gradletest#file_pattern = '\v^([Tt]est.*|.*[Tt]est(s|Case)?)\.java$'
endif

function! test#java#gradletest#test_file(file) abort
  return a:file =~? g:test#java#gradletest#file_pattern
    \ && exists('g:test#java#runner')
    \ && g:test#java#runner ==# 'gradletest'
endfunction

function! test#java#gradletest#build_position(type, position) abort
  let filename = fnamemodify(a:position['file'], ':t:r')

  if a:type ==# 'nearest'
    let name = s:nearest_test(a:position)
    if !empty(name)
      return ['--tests ' . name]
    else
      return ['--tests ' . filename]
    endif
  elseif a:type ==# 'file'
    return ['--tests ' . filename]
  else
    return []
  endif
endfunction

function! test#java#gradletest#build_args(args) abort
  return a:args
endfunction

function! test#java#gradletest#executable() abort
  return 'gradle test'
endfunction

function! s:nearest_test(position) abort
  let name = test#base#nearest_test(a:position, g:test#java#patterns)
  return join(name['namespace'] + name['test'], '.')
endfunction
