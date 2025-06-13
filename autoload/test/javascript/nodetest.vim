if !exists('g:test#javascript#nodetest#file_pattern')
  let g:test#javascript#nodetest#file_pattern = '\v(tests?/.*|\.(spec|test))\.js$'
endif

function! FileContainsTextInFile(filename, pattern)
  if !filereadable(a:filename)
    return 0
  endif
  let lines = readfile(a:filename)
  for line in lines
    if line =~ a:pattern
      return 1
    endif
  endfor
  return 0
endfunction

function! test#javascript#nodetest#test_file(file) abort
  if a:file =~# g:test#javascript#nodetest#file_pattern
        return FileContainsTextInFile(file, 'node:test')
      endif
  endif
endfunction

function! test#javascript#nodetest#build_position(type, position) abort
  if a:type ==# 'nearest'
    return ['--test',a:position['file']]
  elseif a:type ==# 'file'
    return ['--test',a:position['file']]
  else
    return []
  endif
endfunction

function! test#javascript#nodetest#build_args(args) abort
  let args = a:args

  return args
endfunction

function! test#javascript#nodetest#executable() abort
  return 'node'
endfunction
