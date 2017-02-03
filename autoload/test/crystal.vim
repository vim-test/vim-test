let test#crystal#patterns = {
  \ 'test': [
    \ '\v^\s*it%(\(| )%("|'')(.*)%("|'')',
  \],
  \ 'namespace': [
    \ '\v^\s*describe%(\(| )%("|'')(.*)%("|'')',
    \ '\v^\s*describe%(\(| )(\S+)',
  \],
\}
