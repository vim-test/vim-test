if !exists('g:test#python#mamba#file_pattern')
  let g:test#python#mamba#file_pattern = '_spec\.py$'
endif

function! test#python#mamba#test_file(file)
  if fnamemodify(a:file, ':t') =~# g:test#python#mamba#file_pattern
    if exists('g:test#python#runner')
      return g:test#python#runner ==# 'mamba'
    else
      return executable("mamba")
    endif
  endif
endfunction

function! test#python#mamba#build_position(type, position) abort
  if a:type ==# 'nearest'
    let name = s:nearest_test(a:position)
    if !empty(name)
      return [a:position['file'].':'.name]
    else
      return [a:position['file']]
    endif
  elseif a:type ==# 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#python#mamba#build_args(args, color) abort
  let args = a:args

  if !a:color
    let args = ['--color=no'] + args
  endif

  return args
endfunction

function! test#python#mamba#executable() abort
  let pipenv_prefix = ""

  if filereadable("Pipfile")
    let pipenv_prefix = "pipenv run "
  elseif filereadable("poetry.lock")
    let pipenv_prefix = "poetry run "
  endif

  return pipenv_prefix . "mamba"
endfunction

function! s:nearest_test(position) abort
  let name = test#base#nearest_test(a:position, g:test#python#patterns)
  return get(name['test'], 0, '')
endfunction
