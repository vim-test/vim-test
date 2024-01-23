let test#python#patterns = {
  \ 'test':      ['\v^\s*%(async )?def (test_\w+)'],
  \ 'namespace': ['\v^\s*class (\w+)'],
\}

function! test#python#has_import(file, module) abort
  return match(readfile(expand(a:file)), '^\(import ' . a:module . '\)\|\(from ' . a:module . ' import\)') != -1
endfunction

function! test#python#executable() abort
  if executable('python3')
    return 'python3'
  else
    return 'python'
  endif
endfunction
