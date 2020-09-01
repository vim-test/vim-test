if !exists('g:test#javascript#reactscripts#file_pattern')
  let g:test#javascript#reactscripts#file_pattern = '\v(__tests__/.*|(spec|test))\.(js|jsx|coffee|ts|tsx)$'
endif

function! test#javascript#reactscripts#test_file(file) abort
  if a:file =~# g:test#javascript#reactscripts#file_pattern
      if exists('g:test#javascript#runner')
          return g:test#javascript#runner ==# 'reactscripts'
      else
        return test#javascript#has_package('react-scripts')
      endif
  endif
endfunction

function! test#javascript#reactscripts#build_position(type, position) abort
  if a:type ==# 'nearest'
    let name = s:nearest_test(a:position)
    if !empty(name)
      let name = '-t '.shellescape(name, 1)
    endif
    return [name, a:position['file']]
  elseif a:type ==# 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

let s:yarn_command = '\<yarn\>'
function! test#javascript#reactscripts#build_args(args) abort
  if exists('g:test#javascript#reactscripts#executable')
    \ && g:test#javascript#reactscripts#executable =~# s:yarn_command
    return filter(a:args, 'v:val != "--"')
  else
    return a:args
  endif
endfunction

function! test#javascript#reactscripts#executable() abort
  if filereadable('node_modules/.bin/react-app-rewired')
    return 'node_modules/.bin/react-app-rewired test'
  elseif filereadable('node_modules/.bin/react-scripts')
    return 'node_modules/.bin/react-scripts test'
  else
    return 'react-scripts test'
  endif
endfunction

function! s:nearest_test(position) abort
  let name = test#base#nearest_test(a:position, g:test#javascript#patterns)
  return (len(name['namespace']) ? '^' : '') .
       \ test#base#escape_regex(join(name['namespace'] + name['test'])) .
       \ (len(name['test']) ? '$' : '')
endfunction
