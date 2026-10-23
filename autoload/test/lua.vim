let test#lua#patterns = {
  \ 'test':      ['\v^\s*it\s*\(?\s*[''"]{1}([^''"]+)'],
  \ 'namespace': ['\v^\s*describe\s*\(?\s*[''"]{1}([^''"]+)'],
\}

function! test#lua#list_root_markers() abort
  return ['.busted']
endfunction
