if !exists('g:test#php#kahlan#file_pattern')
  let g:test#php#kahlan#file_pattern = '\v(s|S)pec\.php$'
endif

function! test#php#kahlan#test_file(file) abort
  if empty(test#php#kahlan#executable())
    return 0
  endif

  return a:file =~# g:test#php#kahlan#file_pattern
endfunction

function! test#php#kahlan#build_position(type, position) abort
  return []
endfunction

function! test#php#kahlan#build_args(args) abort
  let args = a:args

  if test#base#no_colors()
    let args = ['--no-colors=true'] + args
  endif

  return args
endfunction

function! test#php#kahlan#executable() abort
  if filereadable('./vendor/bin/kahlan')
    return './vendor/bin/kahlan'
  elseif filereadable('./bin/kahlan')
    return './bin/kahlan'
  endif
endfunction
