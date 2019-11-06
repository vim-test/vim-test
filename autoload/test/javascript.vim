let test#javascript#patterns = {
  \ 'test': ['\v^\s*%(it|test)\s*[( ]\s*%("|''|`)(.*)%("|''|`)'],
  \ 'namespace': ['\v^\s*%(describe|suite|context)\s*[( ]\s*%("|''|`)(.*)%("|''|`)'],
\}

function! test#javascript#has_package(package) abort
  let json_path = findfile('package.json', '.;')
  for line in readfile(json_path)
    if line =~ '"'.a:package.'"'
      return 1
    endif
  endfor

  return 0
endfunction
