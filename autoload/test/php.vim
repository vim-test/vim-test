let test#php#patterns = {
  \ 'test':      ['\v^\s*public function (\w*)\('],
  \ 'namespace': [],
\}

if !exists('g:test#php#useparatest')
  let g:test#php#useparatest = 1
endif
