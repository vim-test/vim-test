let g:test#swift#patterns = {
  \ 'test':      ['\v^\s*func (test.*)\(\)'],
  \ 'namespace': ['\v^%(%(public )?%(final )?|%(final )?%(public )?)class ([-_a-zA-Z0-9]+): XCTestCase'],
  \ 'module':    ['\v^Tests\/([-_ a-zA-Z0-9]+)%(\/|\.swift)']
\}
