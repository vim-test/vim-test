if !exists('g:test#javascript#webdriverio#file_pattern')
  let g:test#javascript#webdriverio#file_pattern = '\vtests?/.*\.js$'
endif

function! test#javascript#webdriverio#test_file(file) abort
  return a:file =~# g:test#javascript#webdriverio#file_pattern
    \ && test#javascript#has_package('webdriverio')
    \ && !empty(glob('wdio.conf.js'))
endfunction

function! test#javascript#webdriverio#build_position(type, position) abort
  if a:type == 'nearest' || a:type == 'file'
    return ["--spec", a:position['file']]
  else
    return []
  endif
endfunction

function! test#javascript#webdriverio#build_args(args) abort
  return ['wdio.conf.js'] + a:args
endfunction

function! test#javascript#webdriverio#executable() abort
  if filereadable('node_modules/.bin/wdio')
    return 'node_modules/.bin/wdio'
  else
    return 'wdio'
  endif
endfunction
