let test#javascript#patterns = {
  \ 'test': map(['''', '"', '`'], {_, val -> substitute('\v^\s*%(it|test|describe.each)[^''"`]*__QUOTE__([^__QUOTE__]*)__QUOTE__', '__QUOTE__', val, 'g')}),
  \ 'namespace': map(['''', '"', '`'], {_, val -> substitute('\v^\s*%(describe|suite|context)\s*[( ][^''"`]*__QUOTE__([^__QUOTE__]*)__QUOTE__', '__QUOTE__', val, 'g')})
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
