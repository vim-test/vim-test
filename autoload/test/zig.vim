let test#zig#patterns = {
  \ 'whole_match': 1,
  \ 'test': ['\v^\s*test\s(")\zs%(.{-}%(\\\1)?){-}\ze\1'],
  \ 'namespace': []
\}
