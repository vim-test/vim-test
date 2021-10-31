if !exists('g:test#javascript#denotest#file_pattern')
  let g:test#javascript#denotest#file_pattern = '\v(.*)test\.(js|mjs|ts|jsx|tsx)$'
endif

function! test#javascript#denotest#test_file(file) abort
  if a:file =~# g:test#javascript#denotest#file_pattern
      if exists('g:test#javascript#runner')
          return g:test#javascript#runner ==# 'denotest'
      else
        return !filereadable('package.json')
                    \ && !empty(filter(readfile(a:file), 'v:val =~# ''Deno.test('''))
      endif
  endif
endfunction

function! test#javascript#denotest#build_position(type, position) abort
  if a:type ==# 'nearest'
    let name = s:nearest_test(a:position)
    if !empty(name)
      let name = shellescape(name, 1)
    endif
    return ['--filter', name, a:position['file']]
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

function! s:nearest_test(position) abort
  let patterns = {
    \ 'test': [
    \   '\v^\s*%(name:)\s*%("|'')(.*)%("|'')',
    \   '\v^\s*%(%(Deno\.)?test)\s*[( ]\s*%("|'')(.*)%("|'')',
    \   '\v^\s*%(%(Deno\.)?test)\s*[(][{]\s*%(name:)\s*%("|'')(.*)%("|'')'
    \ ] + g:test#javascript#patterns['test'],
    \ 'namespace': g:test#javascript#patterns['namespace'],
    \}

  let name = test#base#nearest_test(a:position, l:patterns)
  return '/^' . test#base#escape_regex(join(name['test'])) . '$/'
endfunction
