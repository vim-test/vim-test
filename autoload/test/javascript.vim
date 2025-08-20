let test#javascript#patterns = {
  \ 'whole_match': 1,
  \ 'test': ['\v^\s*%(it|test|describe.each)[^''"`]*([''"`])\zs%(.{-}%(\\\1)?){-}\ze\1'],
  \ 'namespace': ['\v^\s*%(describe|suite|context|module)\s*[^''"`]*([''"`])\zs%(.{-}%(\\\1)?){-}\ze\1']
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
  return match(readfile(expand(a:file)), a:import) != -1
endfunction
