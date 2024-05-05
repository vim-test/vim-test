if !exists('g:test#gleam#gleamtest#file_pattern')
  let g:test#gleam#gleamtest#file_pattern = '\v\.gleam$'
endif

function! test#gleam#gleamtest#test_file(file) abort
  return a:file =~# g:test#gleam#gleamtest#file_pattern
endfunction

function! test#gleam#gleamtest#build_position(type, position) abort
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

function! test#gleam#gleamtest#build_args(args)
  if empty(filter(copy(a:args), 'test#base#file_exists(v:val)'))
    call add(a:args, 'build test')
  endif

  return a:args
endfunction

function! test#gleam#gleamtest#executable() abort
  return 'gleam'
endfunction

function! s:nearest_test(position) abort
  let name = test#base#nearest_test(a:position, g:test#gleam#patterns)
  return test#base#escape_regex(join(name['test']))
endfunction
