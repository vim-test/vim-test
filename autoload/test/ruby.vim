let test#ruby#levels = {
  \ 'spec': [
    \ '\v^\s*it %("|'')(.*)%("|'')',
    \ '\v^\s*describe %(%("|'')(.*)%("|'')|(\S+))',
  \],
  \ 'unit': [
    \ '\v^\s*%(def (test_\w+)|test %("|'')(.*)%("|''))',
    \ '\v^\s*%(class|module) (\S+)',
  \],
\}
