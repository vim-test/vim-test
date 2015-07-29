function! test#php#phpunit#test_file(file) abort
  return a:file =~# '\v(t|T)est\.php$'
endfunction

function! test#php#phpunit#build_position(type, position) abort
  if a:type == 'nearest' || a:type == 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#php#phpunit#build_args(args) abort
  return a:args
endfunction

function! test#php#phpunit#executable() abort
  if filereadable('vendor/bin/phpunit')
    return 'vendor/bin/phpunit'
  else
    return 'phpunit'
  endif
endfunction
