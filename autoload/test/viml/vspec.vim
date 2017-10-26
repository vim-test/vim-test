if !exists('g:test#viml#vspec#file_pattern')
  let g:test#viml#vspec#file_pattern = '\v^(t(est)?|spec)/.*\.vim$'
endif

function! test#viml#vspec#test_file(file) abort
  return a:file =~# g:test#viml#vspec#file_pattern
endfunction

function! test#viml#vspec#build_position(type, position) abort
  if a:type ==# 'nearest' || a:type ==# 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#viml#vspec#build_args(args) abort
  if empty(filter(copy(a:args), 'test#base#file_exists(v:val)'))
    let test_dir = get(filter(['t/', 'test/', 'spec/'], 'isdirectory(v:val)'), 0)
    call add(a:args, test_dir)
  endif

  return a:args
endfunction

function! test#viml#vspec#executable() abort
  if !executable('vim-flavor')
    throw '"vim-flavor" executable not found, get it with `gem install vim-flavor`'
  endif

  if filereadable('bin/vim-flavor')
    return 'bin/vim-flavor test'
  elseif filereadable('Gemfile')
    return 'bundle exec vim-flavor test'
  else
    return 'vim-flavor test'
  endif
endfunction
