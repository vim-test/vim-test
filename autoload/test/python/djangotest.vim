if !exists('g:test#python#djangotest#file_pattern')
  let g:test#python#djangotest#file_pattern = '^test_.*\.py$'
endif

function! test#python#djangotest#test_file(file) abort
  if fnamemodify(a:file, ':t') =~# g:test#python#djangotest#file_pattern
    return !empty(findfile('manage.py', '.;'))
  endif
endfunction

function! test#python#djangotest#build_position(type, position) abort
  let path = s:get_import_path(a:position['file'])
  if a:type == 'nearest'
    let name = s:nearest_test(a:position)
    if !empty(name)
      return [path . '.' . name]
    else
      return [path]
    endif
  elseif a:type == 'file'
    return [path]
  else
    return []
  endif
endfunction

function! test#python#djangotest#build_args(args) abort
  return a:args
endfunction

function! test#python#djangotest#executable() abort
  return s:manage_py_path() . '/manage.py test'
endfunction

function! s:get_import_path(filepath) abort
  " Get the full path to the file on disk (without extension).
  let path = fnamemodify(a:filepath, ':p:r')
  " Remove everything up to the folder with the manage.py.
  let path = substitute(path, s:manage_py_path() . '/', '', 'g')
  " Convert the slashes to periods.
  let path = substitute(path, '\/', '.', 'g')
  return path
endfunction!

function! s:manage_py_path() abort
  " Go up the tree looking for the manage.py file and return its path.
  let path = findfile('manage.py', '.;')
  " Get the full path, even if we're in the current directory.
  let path = fnamemodify(path, ':p')
  " Strip the /manage.py from the end.
  return substitute(path, '/manage.py', '', '')
endfunction

function! s:nearest_test(position) abort
  let name = test#base#nearest_test(a:position, g:test#python#patterns)
  return join(name['namespace'] + name['test'], '.')
endfunction
