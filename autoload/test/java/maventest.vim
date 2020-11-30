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
  let module = s:get_maven_module(a:position['file'])
  " ex:  mvn test -Dtest com.you.pkg.App$NestedClass#test_method
  " ex:  mvn test -Dtest com.you.pkg.App#test_method
  " ex:  mvn test -Dtest com.you.pkg.App\*           (catches nested test-classes)
  if a:type ==# 'nearest'
    let name = s:nearest_test(a:position)
    if !empty(name)
      return ['test -Dtest=' . package . '.' . name. module]
    else
      return ['test -Dtest=' . package . '.' . filename . '\*'. module]
    endif

  " ex:  mvn test -Dtest com.you.pkg.App\*  (catches nested test-classes)
  elseif a:type ==# 'file'
    return ['test -Dtest=' . package . '.' . filename . '\*'. module]

  " ex:  mvn verify -Dit.test=App\*  (runs integration tests)
  elseif a:type ==# 'integration'
    return ['verify -Dit.test=' . filename . '\*'. module]
  " ex:  mvn test
  else
    return ['test' . module]
  endif

endfunction

function! test#java#maventest#build_args(args) abort
  return a:args
endfunction

function! test#java#maventest#executable() abort
  return 'mvn'
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
endfunction

function! s:get_maven_module(filepath)
  let project_dir = s:GetJavaProjectDirectory(a:filepath)
  let l:module_name = fnamemodify(project_dir, ':t')
  let l:parent = fnamemodify(project_dir, ':p:h:h')
  if filereadable(l:parent. "/pom.xml") " check if the parent dir has pom.xml
      return ' -pl '. module_name
  else 
      return ''
  endif
endfunction

function! s:GetJavaProjectDirectory(filepath)
    let pomFile = s:GetPomFile(a:filepath)
    if strlen(l:pomFile) > 0
        return fnamemodify(l:pomFile, ':h')
    else
        return 0
    endif
endfunction

function! s:GetPomFile(pwd)
    if a:pwd ==# "\/"
        return 0
    else
        let l:fn = a:pwd . "/pom.xml"

        if filereadable(expand(l:fn))
            return l:fn
        else
            let l:parent = fnamemodify(a:pwd, ':h')
            return s:GetPomFile(l:parent)
        endif
    endif
endfunction

function! s:nearest_test(position) abort
  let name = test#base#nearest_test(a:position, g:test#java#patterns)
  let dtest_str = join(name['namespace'], '$') .'#'. join(name['test'], '$')

  return escape(dtest_str, '#$')
endfunction
