let g:test#groovy#patterns = {
  \ 'test':      ['\v^\s*%(public void (\w+)|def\s*(".*")|def\s*(\w+)\(\))'],
  \ 'namespace': ['\v^\s*%(public )?class (\w+)'],
  \ }
