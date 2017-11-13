if !exists('g:test#erlang#commontest#file_pattern')
  let g:test#erlang#commontest#file_pattern = '\v_SUITE\.erl$'
endif

function! test#erlang#commontest#test_file(file) abort
  return a:file =~# g:test#erlang#commontest#file_pattern
endfunction

function! test#erlang#commontest#build_position(type, position) abort
    if a:type ==# 'nearest'
        let name = s:nearest_test(a:position)
        if !empty(name)
            return ['--suite='.a:position['file'], '--case='.name]
        else
            return ['--suite='.a:position['file']]
        endif
    elseif a:type ==# 'file'
        return ['--suite='.a:position['file']]
    else
        return []
    endif
endfunction

function! test#erlang#commontest#build_args(args) abort
  return  ['ct'] + a:args
endfunction

function! test#erlang#commontest#executable() abort
  return 'rebar3'
endfunction

function! s:nearest_test(position) abort
  let name = test#base#nearest_test(a:position, g:test#erlang#patterns)
  return join(name['test'])
endfunction
