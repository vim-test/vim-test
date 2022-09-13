if !exists('g:test#javascript#playwright#file_pattern')
  let g:test#javascript#playwright#file_pattern = '\v(__tests__/.*|(spec|test))\.(js|jsx|coffee|ts|tsx)$'
endif

function! test#javascript#playwright#test_file(file) abort
  if a:file =~# g:test#javascript#playwright#file_pattern
      if exists('g:test#javascript#runner')
          return g:test#javascript#runner ==# 'playwright'
      else
        return test#javascript#has_package('@playwright/test')
      endif
  endif
endfunction

function! test#javascript#playwright#build_position(type, position) abort
  if a:type ==# 'nearest'
    let name = s:nearest_test(a:position)
    if !empty(name)
      let name = '-g '.shellescape(name, 1)
    endif
    return [name, a:position['file']]
  elseif a:type ==# 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

let s:yarn_command = '\<yarn\>'
function! test#javascript#playwright#build_args(args) abort
  if exists('g:test#javascript#playwright#executable')
    \ && g:test#javascript#playwright#executable =~# s:yarn_command
    return filter(a:args, 'v:val != "--"')
  else
    return a:args
  endif
endfunction

function! test#javascript#playwright#executable() abort
  if filereadable('node_modules/.bin/playwright')
    return 'node_modules/.bin/playwright test'
  else
    return 'playwright test'
  endif
endfunction

let test#playwright#patterns = {
  \ 'test': ['\v^\s*%(test)\s*[( ]\s*%("|''|`)(.*)%("|''|`)'],
  \ 'namespace': ['\v^\s*%(test\.describe)\s*[( ]\s*%("|''|`)(.*)%("|''|`)'],
\}

function! s:nearest_test(position) abort
  let name = test#base#nearest_test(a:position, g:test#playwright#patterns)
  return test#base#escape_regex(join(name['namespace'] + name['test']))
endfunction
