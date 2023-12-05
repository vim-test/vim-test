if !exists('g:test#erlang#eunit#file_pattern')
  let g:test#erlang#eunit#file_pattern = '\v\C_tests\.erl$'
endif

if !exists('g:test#erlang#eunit#test_pattern')
  let g:test#erlang#eunit#test_pattern = '\v\C^\s*(\w+_test_?)\s*\('
endif

function! test#erlang#eunit#test_file(file) abort
  return a:file =~# g:test#erlang#eunit#file_pattern
endfunction

function! test#erlang#eunit#build_position(type, position) abort
  if a:type is# 'nearest'
    let l:function = s:nearest_test(a:position)

    if l:function[-6:] is# '_test_'
      return ['--generator=' . s:module(a:position) . ':' . l:function]
    endif

    if l:function[-5:] is# '_test'
      return ['--test=' . s:module(a:position) . ':' . l:function]
    endif
  endif

  if a:type isnot# 'suite'
    return ['--module=' . s:module(a:position)]
  endif

  return []
endfunction

function! s:module(position) abort
  return fnamemodify(a:position.file, ':t:r')
endfunction

function! s:nearest_test(position) abort
  let l:nearest = test#base#nearest_test(a:position, {
      \ 'test': [g:test#erlang#eunit#test_pattern],
      \ 'namespace': [],
      \})

  return get(l:nearest.test, 0, '')
endfunction

function! test#erlang#eunit#build_args(args) abort
  return  ['eunit'] + a:args
endfunction

function! test#erlang#eunit#executable() abort
  return 'rebar3'
endfunction
