if !exists('g:test#zig#zigtest#file_pattern')
  let g:test#zig#zigtest#file_pattern = '\v\.zig$'
endif

if !exists('g:test#zig#zigtest#test_patterns')
  let g:test#zig#zigtest#test_patterns = {
        \ 'test': [
        \ '\vtest "=([^"]*)"= \{',
        \ ],
        \ 'namespace': []
        \ }
endif

" Returns true if the given file belongs to your test runner
function! test#zig#zigtest#test_file(file) abort
  return a:file =~# g:test#zig#zigtest#file_pattern
endfunction

" Returns test runner's arguments which will run the current file and/or line
function! test#zig#zigtest#build_position(type, position) abort
  if a:type ==# 'nearest'
    let name = test#base#nearest_test(a:position, g:test#zig#zigtest#test_patterns)

    if empty(name['test'])
      return []
    else
      return ['test', a:position['file'], '--test-filter', ''''.name['test'][0].'''']
    endif
  elseif a:type ==# 'file'
    return ['test', a:position['file']]
  else
    return []
  endif
endfunction

" Returns processed args (if you need to do any processing)
function! test#zig#zigtest#build_args(args)
  if empty(filter(copy(a:args), 'test#base#file_exists(v:val)'))
    call add(a:args, 'build test')
  endif

  return a:args
endfunction

" Returns the executable of your test runner
function! test#zig#zigtest#executable() abort
  return 'zig'
endfunction
