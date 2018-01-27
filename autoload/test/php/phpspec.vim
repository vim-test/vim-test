if !exists('g:test#php#phpspec#file_pattern')
  let g:test#php#phpspec#file_pattern = '\v(s|S)pec\.php$'
endif

function! test#php#phpspec#test_file(file) abort
  return a:file =~# g:test#php#phpspec#file_pattern
    \ && !empty(filter(readfile(a:file), 'v:val =~# ''PhpSpec\\ObjectBehavior'''))
endfunction

function! test#php#phpspec#build_position(type, position) abort
  if a:type ==# 'nearest'
    return [a:position['file'].':'.a:position['line']]
  elseif a:type ==# 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#php#phpspec#build_args(args) abort
  let args = a:args

  if test#base#no_colors()
    let args = ['--no-ansi'] + args
  endif

  return ['run'] + args
endfunction

function! test#php#phpspec#executable() abort
  if filereadable('./vendor/bin/phpspec')
    return './vendor/bin/phpspec'
  elseif filereadable('./bin/phpspec')
    return './bin/phpspec'
  else
    return 'phpspec'
  endif
endfunction
