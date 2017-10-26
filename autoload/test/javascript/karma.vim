if !exists('g:test#javascript#karma#file_pattern')
  let g:test#javascript#karma#file_pattern = '\v(test|spec)\.(js|jsx|coffee)$'
endif

function! test#javascript#karma#test_file(file) abort
  return a:file =~? g:test#javascript#karma#file_pattern
    \ && test#javascript#has_package('karma')
endfunction

function! test#javascript#karma#build_position(type, position) abort
  if test#javascript#karma#executable() =~# 'karma-cli-runner'
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
  else
    " There is no easy way to restrict the test files with karma.  Until a way
    " is found to easily accomplish this, we'll get an empty list here
    return []
  endif
endfunction

function! test#javascript#karma#build_args(args) abort
  let args = a:args

  " reduce clutter in the output by only reporting tests and only run once so
  " we take less time & therefore annoy the user less
  call extend(args, ['--single-run', '--no-auto-watch', '--log-level=disable'])

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

function! s:nearest_test(position) abort
  let name = test#base#nearest_test(a:position, g:test#javascript#patterns)
  return join(name['namespace'] + name['test'])
endfunction
