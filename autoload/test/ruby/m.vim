if !exists('g:test#ruby#m#file_pattern')
  let g:test#ruby#m#file_pattern = '\v_test\.rb$'
endif

function! test#ruby#m#test_file(file) abort
  return a:file =~# g:test#ruby#m#file_pattern && test#base#executable('ruby#minitest') ==# 'm'
endfunction

function! test#ruby#m#build_position(type, position) abort
  if a:type ==# 'nearest'
    return [a:position['file'].':'.a:position['line']]
  elseif a:type ==# 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#ruby#m#build_args(args) abort
  return a:args
endfunction

function! test#ruby#m#executable() abort
  if !empty(glob('.zeus.sock'))
    return 'zeus m'
  elseif filereadable('./bin/m') && get(g:, 'test#ruby#use_binstubs', 1)
    return './bin/m'
  elseif filereadable('Gemfile') && get(g:, 'test#ruby#bundle_exec', 1)
    return 'bundle exec m'
  else
    return 'm'
  endif
endfunction
