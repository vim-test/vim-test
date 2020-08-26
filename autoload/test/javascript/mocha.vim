if !exists('g:test#javascript#mocha#file_pattern')
  let g:test#javascript#mocha#file_pattern = '\v(tests?/.*|(test))\.(js|jsx|coffee)$'
endif

function! test#javascript#mocha#test_file(file) abort
  if a:file =~# g:test#javascript#mocha#file_pattern
      if exists('g:test#javascript#runner')
          return g:test#javascript#runner ==# 'mocha'
      else
        return test#javascript#has_package('mocha')
      endif
  endif
endfunction

function! test#javascript#mocha#build_position(type, position) abort
  if a:type ==# 'nearest'
    let name = s:nearest_test(a:position)
    if !empty(name)
      let name = '--grep '.shellescape(name, 1)
    endif
    return [a:position['file'], name]
  elseif a:type ==# 'file'
    return [a:position['file']]
  else
    let test_directory = (split(fnamemodify(a:position['file'], ':h'), '\/')[0])

    if test_directory =~# '\v^tests?$'
        return ['--recursive', test_directory . '/']
    endif

    return ['"' . test_directory . '/**/*.' . fnamemodify(a:position['file'], ':e:e:e') . '"']
  endif
endfunction

function! test#javascript#mocha#build_args(args, color) abort
  let args = a:args

  if !a:color
    let args = ['--no-colors'] + args
    let args = args + ['|', 'sed -e "s///g"']
  endif

  return args
endfunction

function! test#javascript#mocha#executable() abort
  if test#javascript#has_package('mocha-webpack')
    if filereadable('node_modules/.bin/mocha-webpack')
      return 'node_modules/.bin/mocha-webpack'
    else
      return 'mocha-webpack'
    endif
  else
    if filereadable('node_modules/.bin/mocha')
      return 'node_modules/.bin/mocha'
    else
      return 'mocha'
    endif
  endif
endfunction

function! s:nearest_test(position) abort
  let name = test#base#nearest_test(a:position, g:test#javascript#patterns)
  return (len(name['namespace']) ? '^' : '') .
       \ test#base#escape_regex(join(name['namespace'] + name['test'])) .
       \ (len(name['test']) ? '$' : '')
endfunction
