if !exists('g:test#java#maventest#file_pattern')
  let g:test#java#maventest#file_pattern = '\v([Tt]est.*|.*[Tt]est(s|Case)?)\.java$'
endif

function! test#java#maventest#test_file(file) abort
  return a:file =~? g:test#java#maventest#file_pattern
    \ && (!exists('g:test#java#runner') || g:test#java#runner ==# 'maventest')
endfunction

function! test#java#maventest#build_position(type, position) abort
  let filename = fnamemodify(a:position['file'], ':t:r')
  let package = s:get_java_package(a:position['file'])
  let testfile_import = join([package, filename], '.')

  " ex:  mvn test -Dtest com.you.pkg.App$NestedClass#test_method
  " ex:  mvn test -Dtest com.you.pkg.App#test_method
  " ex:  mvn test -Dtest com.you.pkg.App\*           (catches nested test-classes)
  if a:type ==# 'nearest'
    let name = s:nearest_test(a:position)
    if !empty(name)
      return ['-Dtest=' . package . '.' . name]
    else
      return ['-Dtest=' . package . '.' . filename . '\*']
    endif

  " ex:  mvn test -Dtest com.you.pkg.App\*  (catches nested test-classes)
  elseif a:type ==# 'file'
    return ['-Dtest=' . package . '.' . filename . '\*']

  " ex:  mvn test
  else
    return []
  endif

endfunction

function! test#java#maventest#build_args(args) abort
  return a:args
endfunction

function! test#java#maventest#executable() abort
  return 'mvn test'
endfunction

function! s:get_java_package(filepath)
  " abspath to sourcefile
  let abspath = fnamemodify(a:filepath, ':p')
  let abspath = substitute(a:filepath, '\\', '/', 'g')

  " strip path-to-project and maven-boilerplate dir-structure
  let relpath = substitute(abspath, '^.*src/\(main\|test\)/java/', "", "g")
  let package_path = substitute(relpath, '\/[^/]\+$', "", "g")
  let java_package = substitute(package_path, '/', '.', 'g')
  return java_package
endfunc

function! s:nearest_test(position) abort
  let name = test#base#nearest_test(a:position, g:test#java#patterns)
  let dtest_str = join(name['namespace'], '$') .'#'. join(name['test'], '$')

  return escape(dtest_str, '#$')
endfunction
