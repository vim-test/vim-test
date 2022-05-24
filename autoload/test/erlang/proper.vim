if !exists('g:test#erlang#proper#file_pattern')
  let g:test#erlang#proper#file_pattern = '\v\C<prop_.*\.erl$'
end

if !exists('g:test#erlang#proper#test_pattern')
  let g:test#erlang#proper#test_pattern = '\v\C^\s*(prop_\w+)\s*\('
end

function! test#erlang#proper#test_file(file) abort
  return a:file =~# g:test#erlang#proper#file_pattern
endfunction

function! test#erlang#proper#build_position(type, position) abort
  let l:args = []

  if a:type isnot# 'suite'
    let l:args += ['--module=' . s:module(a:position)]
  endif

  if a:type is# 'nearest'
    let l:prop = s:nearest_prop(a:position)

    if !empty(l:prop)
      let l:args += ['--prop=' . l:prop]
    endif
  endif

  return l:args
endfunction

function! s:module(position) abort
  return fnamemodify(a:position.file, ':t:r')
endfunction

function! s:nearest_prop(position) abort
  let l:nearest = test#base#nearest_test(a:position, {
      \ 'test': [g:test#erlang#proper#test_pattern],
      \ 'namespace': [],
      \})

  return get(l:nearest.test, 0, '')
endfunction

function! test#erlang#proper#build_args(args) abort
  return  ['proper'] + a:args
endfunction

function! test#erlang#proper#executable() abort
  return 'rebar3'
endfunction
