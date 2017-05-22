if !exists('g:test#racket#rackunit#file_pattern')
  let g:test#racket#rackunit#file_pattern = '\v(t|T)est\.rkt$'
endif

function! test#racket#rackunit#test_file(file) abort
  return a:file =~# g:test#racket#rackunit#file_pattern
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

function! test#racket#rackunit#executable() abort
  if filereadable('./bin/racket')
    return './bin/racket'
  else
    return 'racket'
  endif
endfunction

function! s:nearest_test(position)
  return 'This functionality is not available in rackunit'
endfunction
