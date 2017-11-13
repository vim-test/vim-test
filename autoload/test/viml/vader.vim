if !exists('g:test#viml#vader#file_pattern')
  let g:test#viml#vader#file_pattern = '\v\.vader$'
endif

function! test#viml#vader#test_file(file) abort
  return a:file =~# g:test#viml#vader#file_pattern
endfunction

function! test#viml#vader#build_position(type, position) abort
  if a:type ==# 'nearest'
    let lines = s:nearest_test(a:position)
    if !empty(lines)
      return [':'.join(lines, ',').'call vader#run(0, "'.a:position['file'].'")']
    else
      return [':call vader#run(0, "'.a:position['file'].'")']
    endif
  elseif a:type ==# 'file'
    return [':call vader#run(0, "'.a:position['file'].'")']
  else
    return [':call vader#run(0, "**/*.vader")']
  endif
endfunction

function! test#viml#vader#build_args(args) abort
  return a:args
endfunction

function! test#viml#vader#executable() abort
endfunction

function! s:nearest_test(position) abort
  let [file, line] = [a:position['file'], a:position['line']]

  for [number, content] in reverse(map(getbufline(file, 1, line), '[v:key + 1, v:val]'))
    if match(content, '^Execute') >= 0
      let line1 = number
      let line = number + 1
      break
    endif
  endfor
  if !exists('line1') | return [] | endif

  for [number, content] in map(getbufline(file, line, '$'), '[v:key + line, v:val]')
    if match(content, '^\S') >= 0
      let line2 = number - 1
      break
    endif
  endfor
  if !exists('line2') | let line2 = len(getbufline(file, 1, '$')) | endif

  return [line1, line2]
endfunction
