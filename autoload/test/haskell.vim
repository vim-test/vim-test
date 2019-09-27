let test#haskell#patterns = {
  \ 'test':      ['\v\s*describe\s"([^"]*)"', '\v^\s*it\s"([^"]*)".*$'],
  \ 'namespace': [],
\}

function! test#haskell#test_file(runner, file_pattern, file) abort
  let current_file = fnamemodify(a:file, ':t')
  if current_file =~? a:file_pattern
    if exists('g:test#haskell#runner')
      return a:runner == g:test#haskell#runner
    else "default runner
      return a:runner == 'stacktest'
    endif
  endif
endfunction
