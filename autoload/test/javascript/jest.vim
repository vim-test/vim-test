if !exists('g:test#javascript#jest#file_pattern')
  let g:test#javascript#jest#file_pattern = '\v(__tests__/.*|(spec|test))\.(js|jsx|coffee|ts|tsx)$'
endif

function! test#javascript#jest#test_file(file) abort
  if a:file =~# g:test#javascript#jest#file_pattern
      if exists('g:test#javascript#runner')
          return g:test#javascript#runner ==# 'jest'
      else
        return test#javascript#has_package('jest')
            \ || !empty(glob('jest.config.*'))
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
  if filereadable('node_modules/.bin/jest')
    return 'node_modules/.bin/jest'
  else
    return 'jest'
  endif
endfunction

function! s:nearest_test(position) abort
  let name = test#base#nearest_test(a:position, g:test#javascript#patterns)
  let full_name = join(name['namespace'] + name['test'])

  " Check if test name contains printf format specifiers (used in test.each)
  " Jest printf specifiers: %s (string), %d/%i (number), %f (float), %o (object), %j (JSON), %% (literal %)
  if full_name =~ '%[sdifoj%]'
    " Find the opening paren before the format specifier and truncate there (including the paren)
    let paren_pos = match(full_name, '(')
    let spec_pos = match(full_name, '%[sdifoj%]')
    if paren_pos >= 0 && paren_pos < spec_pos
      " Don't escape here - let build_position's escape() handle it to avoid double-escaping
      let truncated = full_name[:paren_pos]
      return (len(name['namespace']) ? '^' . test#base#escape_regex(join(name['namespace'])) : '') . truncated
    endif
  endif

  " Regular behavior: full test name with anchors
  return (len(name['namespace']) ? '^' : '') .
       \ test#base#escape_regex(full_name) .
       \ (len(name['test']) ? '$' : '')
endfunction
