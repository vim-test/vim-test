if !exists('g:test#elixir#exunit#file_pattern')
  let g:test#elixir#exunit#file_pattern = '_test\.exs$'
endif

function! test#elixir#exunit#test_file(file) abort
  return a:file =~# g:test#elixir#exunit#file_pattern
endfunction

function! test#elixir#exunit#build_position(type, position) abort
  if a:type == 'nearest'
    return [a:position['file'].':'.a:position['line']]
  elseif a:type == 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#elixir#exunit#build_args(args) abort
  let args = a:args

  if test#base#no_colors()
    let args = ['--no-color'] + args
  endif

  return args
endfunction

function! test#elixir#exunit#executable() abort
  return 'mix test'
endfunction
