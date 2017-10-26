if !exists('g:test#php#codeception#file_pattern')
  let g:test#php#codeception#file_pattern =
        \ '\v((c|C)e(p|s)t\.php$|\.feature$|(t|T)est\.php$)'
endif

function! test#php#codeception#test_file(file) abort
  if a:file =~# g:test#php#codeception#file_pattern
    return filereadable('./codeception.yml')
  endif
endfunction

function! test#php#codeception#build_position(type, position) abort
  if a:type ==# 'nearest'
    let testname = s:nearest_test(a:position)
    let filename = a:position['file']
    if !empty(testname) | let filename .= ':' . testname | endif
    return [filename]
  elseif a:type ==# 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#php#codeception#build_args(args) abort
  let args = a:args

  if test#base#no_colors()
    let args = ['--no-ansi'] + args
  endif

  return ['run'] + args
endfunction

function! test#php#codeception#executable() abort
  if filereadable('./vendor/bin/codecept')
    return './vendor/bin/codecept'
  elseif filereadable('./bin/codecept')
    return './bin/codecept'
  else
    return 'codecept'
  endif
endfunction

function! s:nearest_test(position) abort
  let name = test#base#nearest_test(a:position, g:test#php#patterns)
  return join(name['test'])
endfunction
