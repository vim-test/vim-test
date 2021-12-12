if !exists('g:test#javascript#nx#file_pattern')
  let g:test#javascript#nx#file_pattern = '\v(__tests__/.*|(spec|test))\.(js|jsx|coffee|ts|tsx)$'
endif

function! test#javascript#nx#test_file(file) abort
  if a:file =~# g:test#javascript#nx#file_pattern
      if exists('g:test#javascript#runner')
          return g:test#javascript#runner ==# 'nx'
      else
        return test#javascript#has_package('nx')
      endif
  endif
endfunction

function! test#javascript#nx#build_position(type, position) abort
  if a:type ==# 'nearest'
    let name = s:nearest_test(a:position)
    if !empty(name)
      let name = '-t '.shellescape(name, 1)
    endif
    return [name, '--test-file', a:position['file']]
  elseif a:type ==# 'file'
    return ['--test-file', a:position['file']]
  else
    return []
  endif
endfunction

let s:yarn_command = '\<yarn\>'
function! test#javascript#nx#build_args(args) abort
  if exists('g:test#javascript#nx#executable')
    \ && g:test#javascript#nx#executable =~# s:yarn_command
    return filter(a:args, 'v:val != "--"')
  else
    return a:args
  endif
endfunction

function! test#javascript#nx#executable() abort
  if exists('g:test#javascript#nx#project')
    if filereadable('node_modules/.bin/nx')
      return 'node_modules/.bin/nx test ' . g:test#javascript#nx#project
    else
      return 'nx test ' . g:test#javascript#nx#project
    endif
  endif
  if filereadable('node_modules/.bin/nx')
    return 'node_modules/.bin/nx test'
  else
    return 'nx test'
  endif
endfunction

function! s:nearest_test(position) abort
  let name = test#base#nearest_test(a:position, g:test#javascript#patterns)
  return (len(name['namespace']) ? '^' : '') .
       \ test#base#escape_regex(join(name['namespace'] + name['test'])) .
       \ (len(name['test']) ? '$' : '')
endfunction
