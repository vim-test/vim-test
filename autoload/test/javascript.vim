let test#javascript#patterns = {
  \ 'test': [
    \ '\v^\s*%(%(bdd\.)?it|%(tdd\.)?test)\s*[( ]\s*%("|'')(.*)%("|'')\s*,',
    \ '\v^\s*%("|'')(.*)%("|'')\s*:\s*function\s*[(]'
  \],
  \ 'namespace': [
    \'\v^\s*%(%(bdd\.)?describe|%(tdd\.)?suite|context)\s*[( ]\s*%("|'')(.*)%("|'')\s*,',
    \ '\v^\s*%("|'')(.*)%("|'')\s*:\s*[{]',
    \ '\v^\s*registerSuite\s*[(]\s*[{]\s*name\s*:\s*%("|'')(.*)%("|'')\s*,'
  \],
\}
