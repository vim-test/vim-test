let g:test#dart#fluttertest#patterns = {
  \ 'test':      ['\v^\s*%(test|testWidgets)\(%(''|")(.*)%(''|"),', '\v^\s*%(''|")(.{50,})%(''|"),'],
  \ 'namespace': ['\v^\s*group\(%(''|")(.*)%(''|"),'],
\}

if !exists('g:test#dart#fluttertest#file_pattern')
  let g:test#dart#fluttertest#file_pattern = '\v_test\.dart$'
endif

" Returns true if the given file belongs to your test runner
function! test#dart#fluttertest#test_file(file) abort
  return test#dart#test_file('fluttertest', g:test#dart#fluttertest#file_pattern, a:file)
endfunction

" Returns test runner's arguments which will run the current file and/or line
function! test#dart#fluttertest#build_position(type, position) abort
  if a:type ==# 'nearest'
    let name = s:nearest_test(a:position)
    let quote = ''''
    if stridx(name, '''') > 0
         let quote = '"'
    endif
    if !empty(name)
      return ['--plain-name' . ' ' . quote . substitute(name, "\\", "", "g") . quote .' ' . a:position['file']]
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
function! test#dart#fluttertest#build_args(args) abort
  return a:args
endfunction

" Returns the executable of your test runner
function! test#dart#fluttertest#executable() abort
  return 'flutter test'
endfunction

function! s:nearest_test(position) abort
  let name = test#base#nearest_test(a:position, g:test#dart#fluttertest#patterns)
  return join(name['namespace'] + name['test'], ' ')
endfunction
