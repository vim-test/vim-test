if !exists('g:test#zig#zigtest#file_pattern')
  let g:test#zig#zigtest#file_pattern = '\v\.zig$'
endif

function! test#zig#zigtest#test_file(file) abort
  return a:file =~# g:test#zig#zigtest#file_pattern
endfunction

function! test#zig#zigtest#build_position(type, position) abort
  if a:type ==# 'nearest'
    " --test-filter currently only supports filtering string inclusion, so
    "  multiple tests could match, so instead we run the whole file.
    return ['test', a:position['file']]
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
