let test#scala#patterns = {
  \ 'test':      ['\v^\s*test\((.*)\)', '\v^\s*("[^"]*") in.*$', '\v^\s*%(it|"[^"]*")\sshould\s("[^"]*")'],
  \ 'namespace': [],
\}

function! test#scala#test_file(runner, file_pattern, file) abort
  let current_file = fnamemodify(a:file, ':t')

  if current_file =~? a:file_pattern
    if exists('g:test#scala#runner')
      return a:runner == g:test#scala#runner
    else "default runner
      return a:runner == 'sbttest'
    endif
  endif
endfunction
