if !exists('g:test#groovy#maventest#file_pattern')
  let g:test#groovy#maventest#file_pattern = '\v^([Tt]est.*|.*[Tt]est(s|Case)?|.*[Ss]pec)\.groovy'
endif

function! test#groovy#maventest#test_file(file) abort
  return a:file =~? g:test#groovy#maventest#file_pattern
    \ && exists('g:test#groovy#runner')
    \ && g:test#groovy#runner ==# 'maventest'
endfunction

function! test#groovy#maventest#build_position(type, position) abort
  let filename = fnamemodify(a:position['file'], ':t:r')
  let project_dir = s:maven_project_directory(a:position['file'])
  let package = s:get_groovy_package(a:position['file'])
  let modulename = '-pl ' . s:maven_module_directory(a:position['file'])
  if a:type ==# 'nearest'
    let name = s:nearest_test(a:position)
    if !empty(name)
      return ['test -Dtest=' . package . '.' . name . ' ' . modulename]
    else
      return ['test -Dtest=' . package . '.' . filename . '\* ' . modulename]
    endif
  elseif a:type ==# 'file'
    return ['test -Dtest=' . package . '.' . filename . '\* ' . modulename]
  elseif a:type ==# 'integration'
    return ['test -Dit.test=' . filename . '\* ' . modulename]
  else
    return ['test ' . modulename]
  endif
endfunction

function! test#groovy#maventest#build_args(args) abort
  return a:args
endfunction

function! test#groovy#maventest#executable() abort
  let project_dir = s:maven_project_directory(expand('%'))
  let maven_wrapper = strlen(project_dir) ? s:maven_wrapper_path(fnamemodify(project_dir, ':p')) : ''
  return strlen(maven_wrapper) ? ('./' . maven_wrapper) : 'mvn'
endfunction

function! s:get_groovy_package(filepath)
  " abspath to sourcefile
  let abspath = fnamemodify(a:filepath, ':p')
  let abspath = substitute(a:filepath, '\\', '/', 'g')

  " strip path-to-project and maven-boilerplate dir-structure
  let relpath = substitute(abspath, '^.*src/\(main\|test\)/\(groovy\|java\)/\?', "", "g")
  let package_path = substitute(relpath, '\/[^/]\+$', "", "g")
  let groovy_package = substitute(package_path, '/', '.', 'g')
  return groovy_package
endfunction

function! s:maven_project_directory(filename)
  let project_dir = fnamemodify(findfile('pom.xml', fnamemodify(a:filename, ':p:h') . ';'), ':h')
  let maven_wrapper = strlen(project_dir) ? s:maven_wrapper_path(fnamemodify(project_dir, ':p')) : ''
  if strlen(maven_wrapper)
    return fnamemodify(maven_wrapper, ':h')
  elseif strlen(project_dir)
    return project_dir
  else
    return ''
  endif
endfunction

function! s:maven_module_directory(filename)
  let build_maven = findfile('pom.xml', fnamemodify(a:filename, ':p:h') . ';')
  return strlen(build_maven) ? fnamemodify(build_maven, ':h') : ''
endfunction

function! s:maven_wrapper_path(project_dir)
  return findfile(s:maven_wrapper_filename(), a:project_dir . ';')
endfunction

function! s:maven_wrapper_filename() abort
  return has('win32') ? 'mvnw.cmd' : 'mvnw'
endfunction

function! s:nearest_test(position) abort
  let name = test#base#nearest_test(a:position, g:test#groovy#patterns)
  return join(name['namespace'] + name['test'], '#')
endfunction

function! s:os_slash() abort
  return exists('+shellslash') ? '\' : '/'
endfunction
