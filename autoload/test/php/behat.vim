function! test#php#behat#test_file(file) abort
  if a:file =~# '\.feature$'
    return !empty(glob('features/bootstrap/**/*.php'))
  endif
endfunction

function! test#php#behat#build_position(type, position) abort
  if a:type == 'nearest'
    return [a:position['file'].':'.a:position['line']]
  elseif a:type == 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#php#behat#build_args(args) abort
  return a:args
endfunction

function! test#php#behat#executable() abort
  if filereadable('./bin/behat')
    return './bin/behat'
  else
    return 'behat'
  endif
endfunction
