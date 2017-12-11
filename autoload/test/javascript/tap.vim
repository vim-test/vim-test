if !exists('g:test#javascript#tap#file_pattern')
  let g:test#javascript#tap#file_pattern = '\vtests?/.*\.js$'
endif

if !exists('g:test#javascript#tap#runners')
  let g:test#javascript#tap#runners = ['tape', 'tap']
endif

if !exists('g:test#javascript#tap#reporters')
  let g:test#javascript#tap#reporters = []
endif

function! test#javascript#tap#test_file(file) abort
  return a:file =~# g:test#javascript#tap#file_pattern 
        \ && test#javascript#has_package('tap')
endfunction

function! test#javascript#tap#build_position(type, position) abort
  if a:type ==# 'nearest' || a:type ==# 'file'
    return [a:position['file']]
  else
    return isdirectory('tests/') ? ['"tests/**/*.js"'] : ['"test/**/*.js"']
  endif
endfunction

function! test#javascript#tap#build_args(args) abort
  let args = a:args
  for executable in g:test#javascript#tap#reporters
    if filereadable('node_modules/.bin/' . executable)
      let args = args + ['|', 'node_modules/.bin/' . executable]
    endif
  endfor

  return args
endfunction

function! test#javascript#tap#executable() abort
  for executable in g:test#javascript#tap#runners
    if filereadable('node_modules/.bin/' . executable)
      return 'node_modules/.bin/' . executable
    endif
  endfor

  return ''
endfunction
