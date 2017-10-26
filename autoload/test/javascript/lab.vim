if !exists('g:test#javascript#lab#file_pattern')
  let g:test#javascript#lab#file_pattern = '\vtest/.*\.js$'
endif

function! test#javascript#lab#test_file(file) abort
  if a:file =~# g:test#javascript#lab#file_pattern
    for line in readfile(a:file)
      let pattern = '\v[Ll]ab.script\(\)'
      if line =~# pattern
        return 1
      endif
    endfor
    return 0
  endif
endfunction

function! test#javascript#lab#build_position(type, position) abort
  if a:type ==# 'nearest'
    let name = s:nearest_test(a:position)
    if !empty(name)
      let name = '--grep '.shellescape(name, 1)
    endif
    return [a:position['file'], name]
  elseif a:type ==# 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#javascript#lab#build_args(args) abort
  return a:args
endfunction

function! test#javascript#lab#executable() abort
  if filereadable('node_modules/.bin/lab')
    return 'node_modules/.bin/lab'
  else
    return 'lab'
  endif
endfunction

function! s:nearest_test(position) abort
  let name = test#base#nearest_test(a:position, g:test#javascript#patterns)
  return (len(name['namespace']) ? '^' : '') .
       \ test#base#escape_regex(join(name['namespace'] + name['test'])) .
       \ (len(name['test']) ? '$' : '')
endfunction
