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
