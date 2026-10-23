let test#zig#patterns = {
  \ 'whole_match': 1,
  \ 'test': ['\v^\s*test\s(")\zs%(.{-}%(\\\1)?){-}\ze\1', '\v^\s*test\s*\zs\S+'],
  \ 'namespace': []
\}

function! test#zig#list_root_markers() abort
  return ['build.zig', 'build.zig.zon']
endfunction
