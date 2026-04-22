let test#javascript#patterns = {
  \ 'whole_match': 1,
  \ 'test': ['\v^\s*%(it|test)\.each\(.*\)\s*\(([''"`])\zs%(.{-}%(\\\1)?){-}\ze\1', '\v^\s*%(it|test|describe.each)[^''"`]*([''"`])\zs%(.{-}%(\\\1)?){-}\ze\1'],
  \ 'namespace': ['\v^\s*%(describe)\.each\(.*\)\s*\(([''"`])\zs%(.{-}%(\\\1)?){-}\ze\1', '\v^\s*%(describe|suite|context|module)\s*[^''"`]*([''"`])\zs%(.{-}%(\\\1)?){-}\ze\1']
\}

function! test#javascript#has_package(package) abort
  if !filereadable('package.json')
    return 0
  endif

  let l:packages = readfile('package.json')

  if exists('*json_decode')
    let l:dict = json_decode(join(packages, ''))
    return has_key(get(dict, 'dependencies', {}), a:package) || has_key(get(dict, 'devDependencies', {}),  a:package)
  endif

  for line in packages
    if line =~ '"'.a:package.'"'
      return 1
    endif
  endfor

  return 0
endfunction

function! test#javascript#has_import(file, import) abort
  let l:file = expand(a:file)
  if !filereadable(l:file)
    let l:file = substitute(l:file, '\v\\([()$ ])', '\1', 'g')
  endif

  let l:source = substitute(join(readfile(l:file), "\n"), '\v\_s+', ' ', 'g')

  if s:has_import_style(l:source, '\<from\>\s*', a:import)
    \ || s:has_import_style(l:source, '\<import\>\s*', a:import)
    \ || s:has_import_style(l:source, '\<import\>\s*(\s*', a:import, '\s*)')
    \ || s:has_import_style(l:source, '\<require\>\s*(\s*', a:import, '\s*)')
    return 1
  endif

  return 0
endfunction

function! test#javascript#determine_executable(cmd) abort
  if filereadable('node_modules/.bin/' . a:cmd)
    return 'node_modules/.bin/' . a:cmd
  else
    return a:cmd
  endif
endfunction

function! s:has_import_style(source, before, target, after = '') abort
  let l:target = escape(a:target, '\.^$~[]')
  let l:quote_styles = '[''"`]'
  let l:pattern = a:before . l:quote_styles . l:target . l:quote_styles . a:after
  return a:source =~# l:pattern
endfunction
