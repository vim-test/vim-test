let test#python#patterns = {
  \ 'test':      ['\v^\s*%(async )?def (test\w+)'],
  \ 'namespace': ['\v^\s*class (\w+)'],
\}

function! test#python#has_import(file, module) abort
  return match(readfile(expand(a:file)), '^\(import ' . a:module . '\)\|\(from ' . a:module . ' import\)') != -1
endfunction

function! test#python#executable() abort
  if executable('python3')
    return 'python3'
  else
    return 'python'
  endif
endfunction

function! test#python#pipenv_prefix() abort
  let pipenv_prefix = ""

  if filereadable("Pipfile")
    let pipenv_prefix = "pipenv run "
  elseif filereadable("poetry.lock")
    let pipenv_prefix = "poetry run "
  elseif filereadable("pdm.lock")
    let pipenv_prefix = "pdm run "
  elseif filereadable("uv.lock")
    let pipenv_prefix = "uv run "
  endif

  return pipenv_prefix
endfunction
