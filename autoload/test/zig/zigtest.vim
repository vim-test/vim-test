if !exists('g:test#zig#zigtest#file_pattern')
  let g:test#zig#zigtest#file_pattern = '\v\.zig$'
endif

function! test#zig#zigtest#test_file(file) abort
  return a:file =~# g:test#zig#zigtest#file_pattern
endfunction

function! test#zig#zigtest#build_position(type, position) abort
  if a:type ==# 'nearest'
    let test = s:nearest_test(a:position)
    if test['test_line'] == -1
      return ['test', a:position['file']]
    endif

    let name = test#base#escape_regex(join(test['test']))

    let g:test#last_position['line'] = test['test_line']
    return ['test', a:position['file'],  '--test-filter '.shellescape(name, 1)]
  elseif a:type ==# 'file'
    return ['test', a:position['file']]
  else
    return []
  endif
endfunction

function! test#zig#zigtest#build_args(args)
  if empty(filter(copy(a:args), 'test#base#file_exists(v:val)'))
    call add(a:args, 'build test')
  endif

  return a:args
endfunction

function! test#zig#zigtest#executable() abort
  return 'zig'
endfunction

function! s:nearest_test(position) abort
  let test = test#base#nearest_test(a:position, g:test#zig#patterns)
  if test.test_line == -1
      let test = test#base#nearest_test_in_lines(a:position['file'], a:position['line'], line('$'), g:test#zig#patterns)
  endif
  return test
endfunction
