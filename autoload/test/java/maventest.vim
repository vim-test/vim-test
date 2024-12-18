if !exists('g:test#java#maventest#file_pattern')
  let g:test#java#maventest#file_pattern = '\v([Tt]est.*|.*[Tt]est(s|Case)?)\.java$'
endif

function! test#java#maventest#test_file(file) abort
    if exists('g:test#java#runner') && g:test#java#runner ==# 'maventest'
        return 1
    elseif exists("g:test#java#runner") && g:test#java#runner != 'maventest'
        return 0
    endif
    let l:pomFile = s:GetPomFile(a:file)
    return a:file =~? g:test#java#maventest#file_pattern
                \ && strlen(l:pomFile) > 0
endfunction

function! test#java#maventest#build_position(type, position) abort
  let filename = fnamemodify(a:position['file'], ':t:r')
  let package = s:get_java_package(a:position['file'])
  let module = s:get_maven_module(a:position['file'])
  " ex:  mvn test -Dtest com.you.pkg.App$NestedClass#test_method
  " ex:  mvn test -Dtest com.you.pkg.App#test_method
  " ex:  mvn test -Dtest com.you.pkg.App\*           (catches nested test-classes)
  " ex:  mvn test -Dtest com.you.pkg.App\* -Dsurefire.failIfNoSpecifiedTests=false -am -pl module_name
  " ex:  mvn test -Dtest com.you.pkg.App#test_method -Dsurefire.failIfNoSpecifiedTests=false -am -pl module_name

  if exists('g:test#java#maventest#test_cmd')
    let test_cmd = g:test#java#maventest#test_cmd
  else
    if filename =~# 'IT\|ITCase\|Integration$' && a:type =~# '^nearest\|file$'
      let skip_it_plugins = " -Dsonar.skip=true -Dpit.report.skip=true -Dpit.skip=true -Dpmd.skip=true -Dcheckstyle.skip=true -Ddependency-check.skip=true -Djacoco.skip=true -Dfailsafe.only=true"
      let test_cmd = "verify" . skip_it_plugins . " -Dit.test="
      if module !=# ''
        let module = ' -Dfailsafe.failIfNoSpecifiedTests=false' . module
      endif
    else
      let test_cmd = 'test -Dtest='
      if module !=# ''
        let module = ' -Dsurefire.failIfNoSpecifiedTests=false' . module
      endif
    endif
  endif

  if a:type ==# 'nearest'
    let name = s:nearest_test(a:position)

    if !empty(name)
      return [test_cmd . package . '.' . name. module]
    else
      return [test_cmd . package . '.' . filename . '\*'. module]
    endif

  " ex:  mvn test -Dtest com.you.pkg.App\*  (catches nested test-classes)
  elseif a:type ==# 'file'
    return [test_cmd . package . '.' . filename . '\*'. module]

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
  if findfile('mvnw') ==# 'mvnw'
    return './mvnw'
  else
    return 'mvn'
  endif
endfunction

function! s:get_java_package(filepath)
  " abspath to sourcefile
  let abspath = fnamemodify(a:filepath, ':p')
  let abspath = substitute(a:filepath, '\\', '/', 'g')

  " strip path-to-project and maven-boilerplate dir-structure
  let relpath = substitute(abspath, '^.*src/\(main\|test\)/\(java/\)\?', "", "g")
  let package_path = substitute(relpath, '\/[^/]\+$', "", "g")
  let java_package = substitute(package_path, '/', '.', 'g')
  return java_package
endfunction

function! s:get_maven_module(filepath)
  let project_dir = s:GetJavaProjectDirectory(a:filepath)
  let l:parent = fnamemodify(project_dir, ':p:h:h')

  if filereadable(l:parent. "/pom.xml") " check if the parent dir has pom.xml
      return ' -am -pl '. project_dir
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

function! s:PomFilename(dir)
    let l:fn = a:dir . "/pom.xml"
    if filereadable(expand(l:fn))
        return l:fn
    endif
    return ''
endfunction

function! s:GetFileParentDir(file)
    return fnamemodify(a:file, ':h')
endfunction

function! s:GetPomFile(pwd)
    if a:pwd ==# "\/"
        return 0
    endif

    let l:pomFile =s:PomFilename(a:pwd)

    if strlen(l:pomFile) > 0
        return l:pomFile
    endif

    let l:loops = 0
    let l:parent = s:GetFileParentDir(a:pwd)
    let l:maxFuncDepth = 20
    while !(strlen(l:pomFile) > 0) && l:loops <= l:maxFuncDepth
        let l:pomFile = s:PomFilename(l:parent)
        let l:parent = s:GetFileParentDir(l:parent)
        let l:loops = l:loops + 1
    endwhile

    return l:pomFile
endfunction

function! s:nearest_test(position) abort
  let l:name = test#base#nearest_test(a:position, g:test#java#patterns)
  let l:dtest_str = join(l:name['namespace'], '$') .'#'. join(l:name['test'], '$')

  return escape(l:dtest_str, '#$')
endfunction
