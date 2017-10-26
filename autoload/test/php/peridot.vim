if !exists('g:test#php#peridot#file_pattern')
  let g:test#php#peridot#file_pattern = '\v(s|S)pec\.php$'
endif

function! test#php#peridot#test_file(file) abort
  if empty(test#php#peridot#executable())
    return 0
  endif

  return a:file =~? g:test#php#peridot#file_pattern
endfunction

function! test#php#peridot#build_position(type, position) abort
  if a:type ==# 'nearest' || a:type ==# 'file'
    return [a:position['file']]
  else
    return ['-g *.spec.php']
  endif
endfunction

function! test#php#peridot#build_args(args) abort
  let args = a:args

  if test#base#no_colors()
    let args = ['--no-colors'] + args
  endif

  return args
endfunction

function! test#php#peridot#executable() abort
  if filereadable('./vendor/bin/peridot')
    return './vendor/bin/peridot'
  elseif filereadable('./bin/peridot')
    return './bin/peridot'
  endif
endfunction
