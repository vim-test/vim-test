let test#javascript#patterns = {
  \ 'whole_match': 1,
  \ 'test': ['\v^\s*%(it|test)\.each\(.*\)\s*\(([''"`])\zs%(.{-}%(\\\1)?){-}\ze\1', '\v^\s*%(it|test|describe.each)[^''"`]*([''"`])\zs%(.{-}%(\\\1)?){-}\ze\1'],
  \ 'namespace': ['\v^\s*%(describe)\.each\(.*\)\s*\(([''"`])\zs%(.{-}%(\\\1)?){-}\ze\1', '\v^\s*%(describe|suite|context|module)\s*[^''"`]*([''"`])\zs%(.{-}%(\\\1)?){-}\ze\1']
\}

function! test#javascript#has_package(package) abort
  let l:cached_result = s:check_cached_package(a:package)
  if l:cached_result > -1
    return l:cached_result
  endif

  if test#javascript#search_in_package_config(
    \ {pkg -> has_key(get(pkg, 'dependencies', {}), a:package) ||
      \ has_key(get(pkg, 'devDependencies', {}), a:package)},
    \ {pkg_line -> pkg_line =~# '"'.a:package.'"'})
    return s:add_cached_package(a:package, 1)
  endif

  if executable('node')
    let l:result = system('node -e "try { require.resolve(process.argv[1]); process.exit(0); } catch (e) { process.exit(1); }" ' . shellescape(a:package))
    return s:add_cached_package(a:package, v:shell_error == 0)
  endif

  return s:add_cached_package(a:package, 0)
endfunction

function! test#javascript#has_import(file, import) abort
  return match(readfile(a:file), "^import.*" . a:import) != -1
endfunction

function! test#javascript#determine_executable(cmd) abort
  if filereadable('node_modules/.bin/' . a:cmd)
    return 'node_modules/.bin/' . a:cmd
  else
    return a:cmd
  endif
endfunction

function! test#javascript#search_in_package_config(json_callback, lines_callback, ...) abort
  let l:package_file = findfile('package.json', '.;')
  if empty(l:package_file)
    return 0
  endif
  s:ensure_package_cache()
  let l:package_lines = s:get_cached_package_lines(l:package_file)
  if exists('*json_decode')
    try
      return call(a:json_callback, [json_decode(join(l:package_lines, ''))] + a:000)
    catch
    endtry
  endif

  for l:line in l:package_lines
    if call(a:lines_callback, [l:line] + a:000)
      return 1
    endif
  endfor

  return 0
endfunction

function s:ensure_package_config_cache() abort
  if !exists('s:package_config_cache')
    let s:package_config_cache = {}
  endif
endfunction

function! s:ensure_package_cache() abort
  if !exists('g:test#javascript#package_cache')
    let g:test#javascript#package_cache = {}
  endif
endfunction

function! s:get_cached_package_lines(package_file) abort
  s:ensure_package_config_cache()
  let l:package_path = fnamemodify(a:package_file, ':p')
  let l:package_mtime = getftime(a:package_file)
  if has_key(s:package_config_cache, l:package_path) && get(s:package_config_cache[l:package_path], 'mtime', -1) == l:package_mtime
    return s:package_config_cache[l:package_path]['lines']
  endif

  let l:lines = readfile(a:package_file)
  let s:package_config_cache[l:package_path] = {
    \ 'mtime': l:package_mtime,
    \ 'lines': l:lines,
    \ }
  return l:lines
endfunction

function! s:check_cached_package(package) abort
  s:ensure_package_cache()
  let l:cache_key = getcwd() . '::' . a:package
  if has_key(g:test#javascript#package_cache, l:cache_key)
    return g:test#javascript#package_cache[l:cache_key]
  else
    return -1
  endif
endfunction

function! s:add_cached_package(package, has_package) abort
  s:ensure_package_cache()
  let l:cache_key = getcwd() . '::' . a:package
  let g:test#javascript#package_cache[l:cache_key] = a:has_package
  return a:has_package
endfunction