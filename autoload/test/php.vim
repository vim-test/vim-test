let test#php#patterns = {
  \ 'test':      ['\v^\s*public function (\w*)\('],
  \ 'namespace': [],
\}

function! test#php#list_root_markers() abort
  return ['composer.json']
endfunction
