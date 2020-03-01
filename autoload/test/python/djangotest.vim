if !exists('g:test#python#djangotest#file_pattern')
  let g:test#python#djangotest#file_pattern = '\v^test.*\.py$'
endif

function! test#python#djangotest#test_file(file) abort
  if fnamemodify(a:file, ':t') =~# g:test#python#djangotest#file_pattern
    if exists('g:test#python#runner')
      return index(['djangotest', 'djangonose'], g:test#python#runner) != -1
    else
      return filereadable('manage.py') && executable('django-admin')
    endif
  endif
endfunction

function! test#python#djangotest#build_position(type, position) abort
  let path = s:get_import_path(a:position['file'])
  if a:type ==# 'nearest'
    let name = s:nearest_test(a:position)
    if !empty(name)
      return [path . s:separator() . name]
    else
      return [path]
    endif
  elseif a:type ==# 'file'
    return [path]
  else
    return []
  endif
endfunction

function! test#python#djangotest#build_args(args) abort
  return a:args
endfunction

function! test#python#djangotest#executable() abort
  return 'python manage.py test'
endfunction

function! s:get_import_path(filepath) abort
  " Iterate upwards to find the top level module
  let top_level_module = fnamemodify(a:filepath, ':h')
  while 1
    if filereadable(findfile('__init__.py', top_level_module))
      let top_level_module = fnamemodify(top_level_module, ':h')
    else
      break
    endif
  endwhile
  " Get path to file from cwd and without extension.
  let path = fnamemodify(a:filepath, ':.:r')
  " Replace the /'s in the file path with .'s
  let path = substitute(path, '\/', '.', 'g')
  let path = substitute(path, '\\', '.', 'g')
  " Substring the path to exclude top level module
  let path = substitute(path, top_level_module, '', 'g')
  " Trim leading period
  let path = trim(path, '.')
  return path
endfunction

function! s:nearest_test(position) abort
  let name = test#base#nearest_test(a:position, g:test#python#patterns)
  return join(name['namespace'] + name['test'], '.')
endfunction

function! s:separator() abort
  let python_runner = get(g:, 'test#python#runner', 'djangotest')
  return {'djangotest': '.', 'djangonose': ':'}[python_runner]
endfunction
