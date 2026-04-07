let test#javascript#patterns = {
  \ 'whole_match': 1,
  \ 'test': ['\v^\s*%(it|test)\.each\(.*\)\s*\(([''"`])\zs%(.{-}%(\\\1)?){-}\ze\1', '\v^\s*%(it|test|describe.each)[^''"`]*([''"`])\zs%(.{-}%(\\\1)?){-}\ze\1'],
  \ 'namespace': ['\v^\s*%(describe)\.each\(.*\)\s*\(([''"`])\zs%(.{-}%(\\\1)?){-}\ze\1', '\v^\s*%(describe|suite|context|module)\s*[^''"`]*([''"`])\zs%(.{-}%(\\\1)?){-}\ze\1']
\}

function! test#javascript#find_config_file(pattern, Callback = {path -> 1}) abort
  return !empty(s:resolve_file_path(a:pattern, a:Callback))
endfunction

function! test#javascript#has_package(package) abort
  let l:package_file = s:resolve_file_path('package.json')
  if empty(l:package_file)
    return 0
  endif

  let l:cached_result = s:check_cached_package(l:package_file, a:package)
  if l:cached_result > -1
    return l:cached_result
  endif

  if test#javascript#search_in_package_config(
    \ {pkg -> has_key(get(pkg, 'dependencies', {}), a:package) ||
      \ has_key(get(pkg, 'devDependencies', {}), a:package)},
    \ {pkg_line -> pkg_line =~# '"'.a:package.'"'})
    return s:add_cached_package(l:package_file, a:package, 1)
  endif

  return s:add_cached_package(l:package_file, a:package, 0)
endfunction

function! test#javascript#has_import(file, import) abort
  return match(readfile(a:file), "^import.*" . a:import) != -1
endfunction

function! test#javascript#determine_executable(cmd) abort
  let l:bin = s:find_file_upward('node_modules/.bin/' . a:cmd)
  if !empty(l:bin)
    return l:bin
  endif
  return a:cmd
endfunction

function! test#javascript#search_in_package_config(json_callback, lines_callback) abort
  " Search for package.json starting from the currently open file's directory
  let l:result = test#javascript#find_file_lines('package.json')
  if empty(l:result.lines)
    return 0
  endif
  call s:ensure_package_cache()
  if exists('*json_decode')
    try
      return call(a:json_callback, [json_decode(join(l:result.lines, ''))])
    catch
    endtry
  endif

  for l:line in l:result.lines
    if call(a:lines_callback, [l:line])
      return 1
    endif
  endfor

  return 0
endfunction

function! test#javascript#find_file_lines(path_or_pattern) abort
  let l:path = s:resolve_file_path(a:path_or_pattern)
  if empty(l:path)
    return {'path': '', 'lines': []}
  endif

  call s:ensure_upward_file_cache()
  let l:file_path = fnamemodify(l:path, ':p')
  let l:file_mtime = getftime(l:path)
  if has_key(s:upward_file_cache, l:file_path) && get(s:upward_file_cache[l:file_path], 'mtime', -1) == l:file_mtime
    return {'path': l:file_path, 'lines': s:upward_file_cache[l:file_path]['lines']}
  endif

  let l:lines = readfile(l:path)
  let s:upward_file_cache[l:file_path] = {
    \ 'mtime': l:file_mtime,
    \ 'lines': l:lines,
    \ }
  return {'path': l:file_path, 'lines': l:lines}
endfunction

function! s:ensure_upward_file_cache() abort
  if !exists('s:upward_file_cache')
    let s:upward_file_cache = {}
  endif
endfunction

function! s:ensure_package_cache() abort
  if !exists('g:test#javascript#package_cache')
    let g:test#javascript#package_cache = {}
  endif
endfunction

function! s:get_current_file_search_dir() abort
  let l:current_file = expand('%:p')
  return empty(l:current_file) ? getcwd() : fnamemodify(l:current_file, ':h')
endfunction

function! s:find_file_upward(pattern, Callback = {path -> 1}) abort
  let l:search_dir = s:get_current_file_search_dir()

  while 1
    let l:paths = split(globpath(l:search_dir, a:pattern), "\n")
    for l:path in l:paths
      if empty(l:path)
        continue
      endif

      if call(a:Callback, [l:path])
        return l:path
      endif
    endfor

    let l:parent_dir = fnamemodify(l:search_dir, ':h')
    if l:parent_dir ==# l:search_dir
      return ''
    endif

    let l:search_dir = l:parent_dir
  endwhile
endfunction

function! s:resolve_file_path(path_or_pattern, Callback = {path -> 1}) abort
  let l:path = expand(a:path_or_pattern)
  if filereadable(l:path) && call(a:Callback, [l:path])
    return l:path
  endif

  return s:find_file_upward(a:path_or_pattern, a:Callback)
endfunction

function! s:package_cache_key(package_file, package) abort
  let l:package_path = fnamemodify(a:package_file, ':p')
  let l:package_mtime = getftime(a:package_file)
  return l:package_path . '::' . l:package_mtime . '::' . a:package
endfunction

function! s:check_cached_package(package_file, package) abort
  call s:ensure_package_cache()
  let l:cache_key = s:package_cache_key(a:package_file, a:package)
  if has_key(g:test#javascript#package_cache, l:cache_key)
    return g:test#javascript#package_cache[l:cache_key]
  else
    return -1
  endif
endfunction

function! s:add_cached_package(package_file, package, has_package) abort
  call s:ensure_package_cache()
  let l:cache_key = s:package_cache_key(a:package_file, a:package)
  let g:test#javascript#package_cache[l:cache_key] = a:has_package
  return a:has_package
endfunction
