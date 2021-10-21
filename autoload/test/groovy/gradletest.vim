if !exists('g:test#groovy#gradletest#file_pattern')
  let g:test#groovy#gradletest#file_pattern = '\v^([Tt]est.*|.*[Tt]est(s|Case)?|.*[Ss]pec)\.groovy'
endif

function! test#groovy#gradletest#test_file(file) abort
  return a:file =~? g:test#groovy#gradletest#file_pattern
    \ && exists('g:test#groovy#runner')
    \ && g:test#groovy#runner ==# 'gradletest'
endfunction

function! test#groovy#gradletest#build_position(type, position) abort
  let filename = fnamemodify(a:position['file'], ':t:r')
  let project_dir = s:gradle_project_directory(a:position['file'])
  let modulename = '-p ' . s:gradle_module_directory(a:position['file'])
  if a:type ==# 'nearest'
    let name = s:nearest_test(a:position)
    if !empty(name)
      return ['--tests ' . name . ' ' . modulename]
    else
      return ['--tests ' . filename . ' ' . modulename]
    endif
  elseif a:type ==# 'file'
    return ['--tests ' . filename . ' ' . modulename]
  else
    return [modulename]
  endif
endfunction

function! test#groovy#gradletest#build_args(args) abort
  return a:args
endfunction

function! test#groovy#gradletest#executable() abort
  let project_dir = s:gradle_project_directory(expand('%'))
  let gradle_wrapper = strlen(project_dir) ? s:gradle_wrapper_path(fnamemodify(project_dir, ':p')) : ''
  return strlen(gradle_wrapper) ? ('./' . gradle_wrapper . ' test') : 'gradle test'
endfunction

function! s:gradle_project_directory(filename)
  let project_dir = fnamemodify(findfile('build.gradle', fnamemodify(a:filename, ':p:h') . ';'), ':h')
  let gradle_wrapper = strlen(project_dir) ? s:gradle_wrapper_path(fnamemodify(project_dir, ':p')) : ''
  if strlen(gradle_wrapper)
    return fnamemodify(gradle_wrapper, ':h')
  elseif strlen(project_dir)
    return project_dir
  else
    return ''
  endif
endfunction

function! s:gradle_module_directory(filename)
  let build_gradle = findfile('build.gradle', fnamemodify(a:filename, ':p:h') . ';')
  return strlen(build_gradle) ? fnamemodify(build_gradle, ':h') : ''
endfunction

function! s:gradle_wrapper_path(project_dir)
  return findfile(s:gradle_wrapper_filename(), a:project_dir . ';')
endfunction

function! s:gradle_wrapper_filename() abort
  return has('win32') ? 'gradlew.bat' : 'gradlew'
endfunction

function! s:nearest_test(position) abort
  let name = test#base#nearest_test(a:position, g:test#groovy#patterns)
  return join(name['namespace'] + name['test'], '.')
endfunction

function! s:os_slash() abort
  return exists('+shellslash') ? '\' : '/'
endfunction
