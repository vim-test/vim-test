if !exists('g:test#elixir#exunit#file_pattern')
  let g:test#elixir#exunit#file_pattern = '\v_test\.exs$'
endif

function! test#elixir#exunit#test_file(file) abort
  return a:file =~# g:test#elixir#exunit#file_pattern
endfunction

function! test#elixir#exunit#build_position(type, position) abort
  if test#elixir#exunit#executable() ==# 'mix test'
    if a:type ==# 'nearest'
      return [a:position['file'].':'.a:position['line']]
    elseif a:type ==# 'file'
      return [a:position['file']]
    else
      return []
    endif
  else
    if a:type ==# 'nearest' || a:type ==# 'file'
      return [a:position['file']]
    else
      return ['*.exs']
    end
  end
endfunction

function! test#elixir#exunit#build_args(args) abort
  let args = a:args

  if test#base#no_colors()
    let args = ['--no-color'] + args
  endif

  return args
endfunction

function! test#elixir#exunit#executable() abort
  if filereadable('mix.exs')
    return 'mix test'
  else
    return 'elixir'
  end
endfunction
