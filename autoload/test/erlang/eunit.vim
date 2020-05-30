if !exists('g:test#erlang#eunit#file_pattern')
  let g:test#erlang#eunit#file_pattern = '\v_tests\.erl$'
endif

function! test#erlang#eunit#test_file(file) abort
  return a:file =~# g:test#erlang#eunit#file_pattern
endfunction

function! test#erlang#eunit#build_position(type, position) abort
  let module = fnamemodify(a:position['file'],':t:r')
  if a:type ==# 'nearest' || a:type ==# 'file'
    return ['--module='.module]
  else
    return []
  endif
endfunction

function! test#erlang#eunit#build_args(args) abort
  return  ['eunit'] + a:args
endfunction

function! test#erlang#eunit#executable() abort
  return 'rebar3'
endfunction
