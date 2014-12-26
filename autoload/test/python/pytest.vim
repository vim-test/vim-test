function! test#python#pytest#test_file(file) abort
  if fnamemodify(a:file, ':t') =~# '^test_.*\.py$'
    if exists('g:test#python#runner')
      return g:test#python#runner == 'pytest'
    else
      return executable('py.test')
    endif
  endif
endfunction

function! test#python#pytest#build_position(type, position) abort
  if a:type == 'nearest'
    let name = s:nearest_test(a:position)
    if !empty(name)
      return [a:position['file'].' -k '.name]
    else
      return [a:position['file']]
    endif
  elseif a:type == 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#python#pytest#build_args(args) abort
  return a:args
endfunction

function! test#python#pytest#executable() abort
  return 'py.test'
endfunction

function! s:nearest_test(position) abort
  let name = test#base#nearest_test(a:position, g:test#python#levels)
  return get(name[1], 0, '')
endfunction
