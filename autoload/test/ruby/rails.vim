if !exists('g:test#ruby#rails#file_pattern')
  let g:test#ruby#rails#file_pattern = '_test\.rb$'
endif

function! test#ruby#rails#test_file(file) abort
  return a:file =~# g:test#ruby#rails#file_pattern && exists('b:rails_root')
endfunction

function! test#ruby#rails#build_position(type, position) abort
  if a:type == 'nearest'
    return [a:position['file'].':'.a:position['line']]
  elseif a:type == 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#ruby#rails#build_args(args) abort
  return a:args
endfunction

function! test#ruby#rails#executable() abort
  if system('cat Gemfile.lock') =~# "rails (5\.0\.0)" 
    if !empty(glob('.zeus.sock'))
      return 'zeus rails test'
    elseif filereadable('./bin/rails')
      return './bin/rails test'
    elseif filereadable('Gemfile') && get(g:, 'test#ruby#bundle_exec', 1)
      return 'bundle exec rails test'
    else
      return 'rails test'
    endif
  endif
endfunction
