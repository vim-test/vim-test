if !exists('g:test#python#pytest#file_pattern')
  let g:test#python#pytest#file_pattern = '\v(test_[^/]+|[^/]+_test)\.py$'
endif

function! test#python#pytest#has_config() abort
  return filereadable('pytest.ini') || (filereadable("pyproject.toml") && match(readfile("pyproject.toml"),"[tool.pytest.ini_options]") != -1) || (filereadable("tox.ini") && match(readfile("tox.ini"),"[pytest]") != -1) || (filereadable("setup.cfg") && match(readfile("setup.cfg"),"[tool:pytest]") != -1)
endfunction

function! test#python#pytest#test_file(file) abort
  if fnamemodify(a:file, ':t') =~# g:test#python#pytest#file_pattern
    if exists('g:test#python#runner')
      return g:test#python#runner ==# 'pytest'
    else
      return filereadable('pytest.ini') || test#python#pytest#has_config() || test#python#has_import(a:file, 'pytest') || !test#python#has_import(a:file, 'unittest') && (executable("pytest") || executable("py.test"))
    endif
  endif
endfunction

function! test#python#pytest#build_position(type, position) abort
  if a:type ==# 'nearest'
    let name = s:nearest_test(a:position)
    if !empty(name)
      return [a:position['file'].'::'.name]
    else
      return [a:position['file']]
    endif
  elseif a:type ==# 'class'
    let name = s:nearest_class(a:position)
    if !empty(name)
      return [a:position['file'].'::'.name]
    else
      return [a:position['file']]
    endif
  elseif a:type ==# 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#python#pytest#build_args(args, color) abort
  let args = a:args

  if !a:color
    let args = ['--color=no'] + args
  endif

  return args
endfunction

function! test#python#pytest#executable() abort
  let pipenv_prefix = ""

  if filereadable("Pipfile")
    let pipenv_prefix = "pipenv run "
  elseif filereadable("poetry.lock")
    let pipenv_prefix = "poetry run "
  elseif filereadable("pdm.lock")
    let pipenv_prefix = "pdm run "
  elseif filereadable("uv.lock")
    let pipenv_prefix = "uv run "
  else
    let pipenv_prefix = test#python#executable() . " -m "
  endif

  if executable("py.test") && !executable("pytest")
    return pipenv_prefix . "py.test"
  else
    return pipenv_prefix . "pytest"
  endif
endfunction

function! s:nearest_class(position) abort
  let name = test#base#nearest_test(a:position, g:test#python#patterns)
  let namespace_str = join(name['namespace'], '::')
  let test_id = []

  if !empty(name['namespace'])
      let test_id = test_id + name['namespace']
  endif

  " ex:
  "   /path/to/file.py::TestClass
  let dtest_str = join(test_id, '::')
  return dtest_str
endfunction

function! s:nearest_test(position) abort
  let name = test#base#nearest_test(a:position, g:test#python#patterns)
  let namespace_str = join(name['namespace'], '::')
  let test_id = []

  if !empty(name['namespace'])
      let test_id = test_id + name['namespace']
  endif
  if !empty(name['test'])
      let test_id = test_id + name['test']
  endif

  " ex:
  "   /path/to/file.py::TestClass
  "   /path/to/file.py::TestClass::method
  "   /path/to/file.py::TestClass::NestedClass::method
  let dtest_str = join(test_id, '::')
  return dtest_str
endfunction
