if !exists('g:test#javascript#tape#file_pattern')
  let g:test#javascript#tape#file_pattern = '\v(tests?/.*|\.(spec|test))\.js$'
endif

if !exists('g:test#javascript#tape#reporters')
  let g:test#javascript#tape#reporters = []
endif

function! test#javascript#tape#test_file(file) abort
  if a:file =~# g:test#javascript#tape#file_pattern
    if exists('g:test#javascript#runner')
      return g:test#javascript#runner ==# 'tape'
    else
      return test#javascript#has_package('tape')
    endif
  endif
endfunction

function! test#javascript#tape#build_position(type, position) abort
  if a:type ==# 'nearest'
    return [a:position['file']]
  elseif a:type ==# 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#javascript#tape#build_args(args) abort
  let args = a:args
  for executable in g:test#javascript#tape#reporters
    if filereadable('node_modules/.bin/' . executable)
      let args = args + ['|', 'node_modules/.bin/' . executable]
    endif
  endfor

  return args
endfunction

function! test#javascript#tape#executable() abort
  return test#javascript#determine_executable('tape')
endfunction

function! s:nearest_test(position) abort
  let patterns = {
        \ 'test': ['\v^\s*%(%(%(tap|t)\.)?test)\s*[( ]\s*%("|''|`)(.*)%("|''|`)'],
        \ 'namespace': [],
        \}
  let name = test#base#nearest_test(a:position, patterns)
  return join(name['test'])
endfunction
