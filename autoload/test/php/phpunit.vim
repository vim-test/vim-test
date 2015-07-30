if !exists('g:test#php#phpunit#file_pattern')
  let g:test#php#phpunit#file_pattern = '\v(t|T)est\.php$'
endif

function! test#php#phpunit#test_file(file) abort
  return a:file =~# g:test#php#phpunit#file_pattern
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
  if filereadable('./vendor/bin/phpunit')
    return './vendor/bin/phpunit'
  elseif filereadable('./bin/phpunit')
    return './bin/phpunit'
  else
    return 'phpunit'
  endif
endfunction
