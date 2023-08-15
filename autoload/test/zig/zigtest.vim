if !exists('g:test#zig#zigtest#file_pattern')
  let g:test#zig#zigtest#file_pattern = '\v\.zig$'
endif

function! test#zig#zigtest#test_file(file) abort
  return a:file =~# g:test#zig#zigtest#file_pattern
endfunction

function! test#zig#zigtest#build_position(type, position) abort
  if a:type ==# 'nearest'
    let name = s:nearest_test(a:position)
    if empty(name)
      return ['test', a:position['file']]
    endif

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
  let name = test#base#nearest_test(a:position, g:test#zig#patterns)
  return test#base#escape_regex(join(name['test']))
endfunction
