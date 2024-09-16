if !exists('g:test#erlang#commontest#file_pattern')
  let g:test#erlang#commontest#file_pattern = '\v\C_SUITE\.erl$'
endif

if !exists('g:test#erlang#commontest#test_pattern')
  let g:test#erlang#commontest#test_pattern = '\v\C^\s*(%(t|test)_\w+)\s*\('
endif

function! test#erlang#commontest#test_file(file) abort
  return a:file =~# g:test#erlang#commontest#file_pattern
endfunction

function! test#erlang#commontest#build_position(type, position) abort
  let l:args = []

  if a:type isnot# 'suite'
    let l:args += ['--suite=' . a:position.file]
  endif

  if a:type is# 'nearest'
    let l:case = s:nearest_test(a:position)

    if !empty(l:case)
      let l:args += ['--case=' . l:case]
    endif
  endif

  return l:args
endfunction

function! s:nearest_test(position) abort
  let l:nearest = test#base#nearest_test(a:position, {
      \ 'test': [g:test#erlang#commontest#test_pattern],
      \ 'namespace': [],
      \})

  return get(l:nearest.test, 0, '')
endfunction

function! test#erlang#commontest#build_args(args) abort
  return  ['ct'] + a:args
endfunction

function! test#erlang#commontest#executable() abort
  return 'rebar3'
endfunction
