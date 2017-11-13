if !exists('g:test#elixir#espec#file_pattern')
  let g:test#elixir#espec#file_pattern = '\v_spec\.exs$'
endif

function! test#elixir#espec#test_file(file) abort
  return a:file =~# g:test#elixir#espec#file_pattern
endfunction

function! test#elixir#espec#build_position(type, position) abort
  if a:type ==# 'nearest'
    return [a:position['file'].':'.a:position['line']]
  elseif a:type ==# 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#elixir#espec#build_args(args) abort
 return a:args
endfunction

function! test#elixir#espec#executable() abort
    return 'mix espec'
endfunction
