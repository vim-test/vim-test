let test#python#patterns = {
  \ 'test':      ['\v^\s*%(async )?def (test_\w+)'],
  \ 'namespace': ['\v^\s*class (Test\w+)|(\w+)\(unittest\.TestCase\)'],
\}
