if !exists('g:test#python#pyunit#file_pattern')
  let g:test#python#pyunit#file_pattern = '\v(^test.*|test)\.py$'
endif

function! test#python#pyunit#test_file(file) abort
  if fnamemodify(a:file, ':t') =~# g:test#python#pyunit#file_pattern
    if exists('g:test#python#runner')
      return g:test#python#runner ==# 'pyunit'
    else
      return test#python#has_import(a:file, 'unittest')
    endif
  endif
endfunction

function! test#python#pyunit#build_position(type, position) abort
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

function! test#python#pyunit#build_args(args) abort
  return a:args
endfunction

function! test#python#pyunit#executable() abort
  let pipenv_prefix = ""

  if filereadable("Pipfile")
    let pipenv_prefix = "pipenv run "
  elseif filereadable("uv.lock")
    let pipenv_prefix = "uv run "
  endif

  return pipenv_prefix . test#python#executable() . ' -m unittest'
endfunction

function! s:get_import_path(filepath) abort
  " Get path to file from cwd and without extension.
  let path = fnamemodify(a:filepath, ':.:r')
  " Replace the /'s in the file path with .'s
  let path = substitute(path, '\/', '.', 'g')
  let path = substitute(path, '\\', '.', 'g')
  return path
endfunction

function! s:nearest_test(position) abort
  let name = test#base#nearest_test(a:position, g:test#python#patterns)
  return join(name['namespace'] + name['test'], '.')
endfunction

function! s:separator() abort
  let python_runner = get(g:, 'test#python#runner', 'pyunit')
  return {'pyunit': '.'}[python_runner]
endfunction
