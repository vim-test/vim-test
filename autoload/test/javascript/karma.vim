if !exists('g:test#javascript#karma#file_pattern')
  let g:test#javascript#karma#file_pattern = '\v(test|spec)\.(js|jsx|coffee)$'
endif

" let s:karma_file = expand('<sfile>:p:h', 1) . '/karma-args'

function! test#javascript#karma#test_file(file) abort
  if empty(test#javascript#karma#executable())
    return 0
  endif

  return  a:file =~? g:test#javascript#karma#file_pattern
endfunction

function! test#javascript#karma#build_position(type, position) abort
  if a:type ==# 'nearest'
    let specname = s:nearest_test(a:position)
    let filename = '--files ' . expand(a:position['file'])
    if empty(specname)
      return [filename]
    endif
    let specname = '--filter ' . shellescape(specname, 1)
    return [filename, specname]
  elseif a:type ==# 'file'
    return ['--files ' . expand(a:position['file'])]
  else
    return []
  endif
endfunction

function! test#javascript#karma#build_args(args) abort
  let args = a:args

  if test#base#no_colors()
    let args = ['--no-color'] + args
  endif

  return args
endfunction

function! test#javascript#karma#executable() abort
  if filereadable('node_modules/karma-cli-runner/karma-args.js')
    return 'node node_modules/karma-cli-runner/karma-args'
  elseif filereadable('node_modules/.bin/karma')
    return 'node_modules/.bin/karma start --single-run'
  endif
endfunction

function! s:nearest_test(position)
  let name = test#base#nearest_test(a:position, g:test#javascript#patterns)
  return join(name['namespace'] + name['test'])
endfunction
