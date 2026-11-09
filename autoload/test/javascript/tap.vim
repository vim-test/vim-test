if !exists('g:test#javascript#tap#file_pattern')
  let g:test#javascript#tap#file_pattern = '\v(tests?/.*|\.(spec|test))\.js$'
endif

function! test#javascript#tap#test_file(file) abort
  if a:file =~# g:test#javascript#tap#file_pattern
    return test#javascript#has_package('tap')
  endif
endfunction

function! test#javascript#tap#build_position(type, position) abort
  if a:type ==# 'nearest'
    let name = s:nearest_test(a:position)
    if !empty(name)
      let name = '--grep='.shellescape(name, 1)
    endif
    return [a:position['file'], name]
  elseif a:type ==# 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#javascript#tap#build_args(args) abort
  let args = a:args

  return args
endfunction

function! test#javascript#tap#executable() abort
  return test#javascript#determine_executable('tap')
endfunction

function! s:nearest_test(position) abort
  let patterns = {
        \ 'test': ['\v^\s*%(%(%(tap|t)\.)?test)\s*[( ]\s*%("|''|`)(.*)%("|''|`)'],
        \ 'namespace': [],
        \}
  let name = test#base#nearest_test(a:position, patterns)
  return join(name['test'])
endfunction
