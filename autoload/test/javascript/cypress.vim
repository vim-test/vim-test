if !exists('g:test#javascript#cypress#file_pattern')
  let g:test#javascript#cypress#file_pattern = '\v(__tests__/.*|(spec|test|cy))\.(js|jsx|coffee|ts|tsx)$'
endif

function! test#javascript#cypress#test_file(file) abort
  if a:file =~# g:test#javascript#cypress#file_pattern
      if exists('g:test#javascript#runner')
          return g:test#javascript#runner ==# 'cypress'
      else
        return test#javascript#has_package('cypress')
      endif
  endif
endfunction

function! test#javascript#cypress#build_position(type, position) abort
  if a:type ==# 'nearest' || a:type ==# 'file'
    return ['run', '--spec', a:position['file']]
  else
    return ['run']
  endif
endfunction

let s:yarn_command = '\<yarn\>'
function! test#javascript#cypress#build_args(args) abort
  if exists('g:test#javascript#cypress#executable')
    \ && g:test#javascript#cypress#executable =~# s:yarn_command
    return filter(a:args, 'v:val != "--"')
  else
    return a:args
  endif
endfunction

function! test#javascript#cypress#executable() abort
  if filereadable('node_modules/.bin/cypress')
    return 'node_modules/.bin/cypress'
  else
    return 'cypress'
  endif
endfunction

function! s:nearest_test(position) abort
  let name = test#base#nearest_test(a:position, g:test#javascript#patterns)
  return (len(name['namespace']) ? '^' : '') .
       \ test#base#escape_regex(join(name['namespace'] + name['test'])) .
       \ (len(name['test']) ? '$' : '')
endfunction
