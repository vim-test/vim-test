if !exists('g:test#javascript#teenytest#file_pattern')
  let g:test#javascript#teenytest#file_pattern = '\vtests?/.*\.(js)$'
endif

function! test#javascript#teenytest#test_file(file) abort
  if a:file =~# g:test#javascript#teenytest#file_pattern
      if exists('g:test#javascript#runner')
          return g:test#javascript#runner ==# 'teenytest'
      else
        return test#javascript#has_package('teenytest')
      endif
  endif
endfunction

function! test#javascript#teenytest#build_position(type, position) abort
  if a:type == 'nearest'
    return [a:position['file'] . ':' . a:position['line']]
  elseif a:type == 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#javascript#teenytest#build_args(args, color) abort
  return a:args
endfunction

function! test#javascript#teenytest#executable() abort
  if filereadable('node_modules/.bin/teenytest')
    return 'node_modules/.bin/teenytest'
  else
    return 'teenytest'
  endif
endfunction
