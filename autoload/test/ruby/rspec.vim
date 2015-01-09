function! test#ruby#rspec#test_file(file) abort
  return a:file =~# '_spec\.rb$'
endfunction

function! test#ruby#rspec#build_position(type, position) abort
  if a:type == 'nearest'
    return [a:position['file'].':'.a:position['line']]
  elseif a:type == 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#ruby#rspec#build_args(args) abort
  return a:args
endfunction

function! test#ruby#rspec#executable() abort
  if !empty(glob('.zeus.sock'))
    return 'zeus rspec'
  elseif filereadable('./bin/rspec')
    return './bin/rspec'
  elseif filereadable('Gemfile')
    return 'bundle exec rspec'
  else
    return 'rspec'
  endif
endfunction
