let test#ruby#patterns = {
  \ 'test': [
    \ '\v^\s*def (test_\w+)',
    \ '\v^\s*test%(\(| )%("|'')(.*)%("|'')',
    \ '\v^\s*it%(\(| )%("|'')(.*)%("|'')',
    \ '\v^\s*it\s\{(.*)\s\}',
  \],
  \ 'namespace': [
    \ '\v^\s*%(class|module) (\S+)',
    \ '\v^\s*%(describe|context)%(\(| )%("|'')(.*)%("|'')',
    \ '\v^\s*%(describe|context)%(\(| )(\S+)',
  \],
\}

function! test#ruby#use_zeus() abort
  return !empty(glob('.zeus.sock'))
endfunction

function! test#ruby#use_bundle_exec() abort
  return filereadable('Gemfile') && get(g:, 'test#ruby#bundle_exec', 1)
endfunction
