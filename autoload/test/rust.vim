let test#rust#patterns = {
  \ 'test': ['\v\s*%(async )?fn\s+(\w+)'],
  \ 'namespace': []
\ }

function! test#rust#module_path_at_line(filename, line) abort
  let lines = readfile(a:filename)
  let stack = []
  let depth = 0
  let lnum = 1
  while lnum <= a:line && lnum <= len(lines)
    let line = lines[lnum - 1]
    if line =~# '\v^\s*mod\s+\w+\s*\{'
      let m = matchlist(line, '\v^\s*mod\s+(\w+)')
      if len(m) > 1
        call add(stack, [m[1], depth])
      endif
    endif
    let open_count = len(split(line, '{', 1)) - 1
    let close_count = len(split(line, '}', 1)) - 1
    let depth = depth + open_count - close_count
    while !empty(stack) && depth <= stack[-1][1]
      call remove(stack, -1)
    endwhile
    let lnum += 1
  endwhile
  return join(map(copy(stack), 'v:val[0]'), '::')
endfunction
