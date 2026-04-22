if !exists('g:test#javascript#jest#file_pattern')
  let g:test#javascript#jest#file_pattern = '\v(__tests__/.*|(spec|test))\.(js|jsx|coffee|ts|tsx)$'
endif

function! test#javascript#jest#test_file(file) abort
  if a:file =~# g:test#javascript#jest#file_pattern
      if exists('g:test#javascript#runner')
          return g:test#javascript#runner ==# 'jest'
      else
        return test#javascript#has_import(a:file, 'jest')
            \ || test#javascript#has_package('jest')
      endif
  endif
endfunction

function! test#javascript#jest#build_position(type, position) abort
  let file = escape(a:position['file'], '()[]')
  if a:type ==# 'nearest'
    let name = s:nearest_test(a:position)
    if !empty(name)
      let name = '-t '.shellescape(escape(name, '()[]'), 1)
    endif
    return ['--runTestsByPath', name, '--', file]
  elseif a:type ==# 'file'
    return ['--runTestsByPath', '--', file]
  else
    return []
  endif
endfunction

let s:yarn_command = '\<yarn\>'
function! test#javascript#jest#build_args(args) abort
  if exists('g:test#javascript#jest#executable')
    \ && g:test#javascript#jest#executable =~# s:yarn_command
    return filter(a:args, 'v:val != "--"')
  else
    return a:args
  endif
endfunction

function! test#javascript#jest#executable() abort
  return test#javascript#determine_executable('jest')
endfunction

function! s:nearest_test(position) abort
  let name = test#base#nearest_test(a:position, g:test#javascript#patterns)
  let test_name = join(name['namespace'] + name['test'])
  let has_printf = test_name =~# '\v\%[sdifojp#]'
  if has_printf
    let test_name = substitute(test_name, '\v\%[sdifojp#].*', '', '')
    return (len(name['namespace']) ? '^' : '') . test_name
  endif
  return (len(name['namespace']) ? '^' : '') .
       \ test#base#escape_regex(test_name) .
       \ (len(name['test']) ? '$' : '')
endfunction
