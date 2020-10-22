if !exists('g:test#javascript#cucumberjs#file_pattern')
  let g:test#javascript#cucumberjs#file_pattern = '\v\.feature$'
endif

function! test#javascript#cucumberjs#test_file(file) abort
  if a:file =~# g:test#javascript#cucumberjs#file_pattern
      if exists('g:test#javascript#runner')
          return g:test#javascript#runner ==# 'cucumber'
      else
        return test#javascript#has_package('cucumber')
      endif
  endif
endfunction

function! test#javascript#cucumberjs#build_position(type, position) abort
  if a:type ==# 'nearest'
    let line = s:nearest_test(a:position)
    if line >= 0
      return [a:position['file'].':'.line]
    endif

    return [a:position['file'].':'.a:position['line']]
  elseif a:type ==# 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#javascript#cucumberjs#build_args(args) abort
  return a:args
endfunction

function! test#javascript#cucumberjs#executable() abort
  if filereadable('node_modules/.bin/cucumber-js')
    return 'node_modules/.bin/cucumber-js'
  else
    return 'cucumber-js'
  endif
endfunction

function! s:nearest_test(position) abort
  let i = a:position['line']
  while i >= 0
    let line = getbufline(a:position['file'], i)
    let scenario_match = matchlist(line, '\v^\s*%(Scenario:)')

    if !empty(scenario_match)
      break
    endif

    let i -= 1
  endwhile

  return i
endfunction
