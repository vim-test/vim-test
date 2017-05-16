let test#javascript#patterns = {
  \ 'test': ['\v^\s*%(it|test)\s*[( ]\s*%("|'')(.*)%("|'')'],
  \ 'namespace': ['\v^\s*%(describe|suite|context)\s*[( ]\s*%("|'')(.*)%("|'')'],
\}

function! test#javascript#has_package(package) abort
  exec "silent grep! '\b".a:package."\b' package.json"

  return len(getqflist()) > 0
endfunction
