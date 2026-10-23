let test#haskell#patterns = {
  \ 'test':      [ '\v\s*\zsdescribe\s"([^"]*)"'
                \, '\v\s*\zsit\s"([^"]*)".*$'
                \, '\v\s*\zsprop\s"([^"]*)".*$'
                \],
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

function! test#haskell#list_root_markers() abort
  return ['stack.yaml', 'cabal.project', 'package.yaml']
endfunction
