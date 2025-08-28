if !exists('g:test#viml#themis#file_pattern')
  let g:test#viml#themis#file_pattern = '\v\.vim(spec)?$'
endif

function! test#viml#themis#test_file(file) abort
  if a:file !~# g:test#viml#themis#file_pattern
    return v:false
  endif
  " themis-style-basic
  if a:file =~# '\.vim$' && !empty(filter(readfile(a:file), 'v:val =~# ''\<themis#suite\s*('''))
    return v:true
  endif
  " themis-style-vimspec
  if a:file =~# '\.vimspec$' && !empty(filter(readfile(a:file), 'v:val =~# ''\v^\s*([Dd]escribe|[Cc]ontext)\s'''))
    return v:true
  endif
  return v:false
endfunction

" Available granularities:
" - Nearest: 'vimspec' syntax only
" - Suite:   No
" - Class:   No
function! test#viml#themis#build_position(type, position) abort
  if a:type ==# 'nearest'
    let target = s:nearest_test(a:position)
    if !empty(target)
      return [a:position['file'], '--target', target]
    else
      return [a:position['file']]
    endif
  elseif a:type ==# 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#viml#themis#build_args(args) abort
  return a:args
endfunction

function! test#viml#themis#executable() abort
  return 'themis'
endfunction

let s:spec_patterns = {
  \ 'test': [
    \ '\v^\s*[iI]t\s+(.+)',
  \],
  \ 'namespace': [
    \ '\v^\s*%([Dd]escribe|[Cc]ontext)\s+(\S.*)',
  \],
\}

function! s:nearest_test(position) abort
  let syntax = s:syntax(a:position['file'])
  let target = ''

  if syntax ==# 'vimspec'
    let name = test#base#nearest_test(a:position, s:spec_patterns)

    if !empty(name['test'])
      let target = shellescape(name['test'][0])
    endif
  endif

  return target
endfunction

function! s:syntax(file) abort
  " themis-style-basic
  if a:file =~# '\.vim$'
    return 'basic'
  endif

  " themis-style-vimspec
  if a:file =~# '\.vimspec$'
    return 'vimspec'
  endif

  return ''
endfunction
