let g:test#dart#darttest#patterns = {
  \ 'test':      ['\v^\s*%(test)\(%(''|")(.*)%(''|"),'],
  \ 'namespace': ['\v^\s*group\(%(''|")(.*)%(''|"),'],
\}

if !exists('g:test#dart#darttest#file_pattern')
  let g:test#dart#darttest#file_pattern = '\v_test\.dart$'
endif

" Returns true if the given file belongs to your test runner
function! test#dart#darttest#test_file(file) abort
  return test#dart#test_file('darttest', g:test#dart#darttest#file_pattern, a:file)
endfunction

" Returns test runner's arguments which will run the current file and/or line
function! test#dart#darttest#build_position(type, position) abort
  if a:type ==# 'nearest'
    let name = s:nearest_test(a:position)
    if !empty(name)
      return ['--plain-name' . ' "' . substitute(name, "\\", "", "g") . '" ' . a:position['file']]
    else
      return [a:position['file']]
    endif
  elseif a:type ==# 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

" Returns processed args (if you need to do any processing)
function! test#dart#darttest#build_args(args) abort
  return a:args
endfunction

" Returns the executable of your test runner
function! test#dart#darttest#executable() abort
  return 'dart test'
endfunction

function! s:nearest_test(position) abort
  let name = test#base#nearest_test(a:position, g:test#dart#darttest#patterns)
  return join(name['namespace'] + name['test'], ' ')
endfunction
