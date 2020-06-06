if !exists('g:test#javascript#denotest#file_pattern')
  let g:test#javascript#denotest#file_pattern = '\v(.*)test\.(js|mjs|ts|jsx|tsx)$'
endif

function! test#javascript#denotest#test_file(file) abort
  return a:file =~# g:test#javascript#denotest#file_pattern
    \ && !filereadable('package.json')
    \ && !empty(filter(readfile(a:file), 'v:val =~# ''Deno.test('''))
endfunction

function! test#javascript#denotest#build_position(type, position) abort
  if a:type ==# 'nearest'
    return [a:position['file']]
  elseif a:type ==# 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#javascript#denotest#build_args(args) abort
  return a:args
endfunction

function! test#javascript#denotest#executable() abort
  return 'deno test'
endfunction
