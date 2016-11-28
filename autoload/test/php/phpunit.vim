if !exists('g:test#php#phpunit#file_pattern')
  let g:test#php#phpunit#file_pattern = '\v(t|T)est\.php$'
endif

function! test#php#phpunit#test_file(file) abort
  return a:file =~# g:test#php#phpunit#file_pattern
endfunction

function! test#php#phpunit#build_position(type, position) abort
  if a:type == 'nearest'
    let name = s:nearest_test(a:position)
    if !empty(name) | let name = '--filter '.shellescape(name, 1) | endif
    return [name, a:position['file']]
  elseif a:type == 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#php#phpunit#build_args(args) abort
  let args = a:args

  if !test#base#no_colors()
    let args = ['--colors'] + args
  endif

  return args
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

function! s:nearest_test(position)
  let name = test#base#nearest_test(a:position, g:test#php#patterns)
  return join(name['test'])
endfunction
