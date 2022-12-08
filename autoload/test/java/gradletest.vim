if !exists('g:test#java#gradletest#file_pattern')
  let g:test#java#gradletest#file_pattern = '\v([Tt]est.*|.*[Tt]est(s|Case)?)\.java$'
endif

function! test#java#gradletest#test_file(file) abort
    if exists("g:test#java#runner") && g:test#java#runner == 'gradletest'
        return 1
    elseif exists("g:test#java#runner") && g:test#java#runner != 'gradletest'
        return 0
    endif
    let l:gradleFiles = s:GetBuildFile(a:file)
    return a:file =~? g:test#java#gradletest#file_pattern
                \ && strlen(l:gradleFiles) > 0
endfunction

function! test#java#gradletest#build_position(type, position) abort
  let filename = fnamemodify(a:position['file'], ':t:r')
  let modulename = s:get_maven_module(a:position['file'])
  if a:type ==# 'nearest'
    let name = s:nearest_test(a:position)
    if !empty(name)
      return ['--tests ' . name. modulename]
    else
      return ['--tests ' . filename. modulename]
    endif
  elseif a:type ==# 'file'
    return ['--tests ' . filename. modulename]
  else
    return [modulename]
  endif
endfunction

function! test#java#gradletest#build_args(args) abort
  return a:args
endfunction

function! s:get_maven_module(filepath)
  let l:project_dir = fnamemodify(s:GetJavaProjectDirectory(a:filepath), ':p:h')
  let l:project_root = l:project_dir

  while !filereadable(l:project_root.'/settings.gradle') && !filereadable(l:project_root.'/settings.gradle.kts')
    let l:project_root = fnamemodify(l:project_root, ':h')
    if l:project_root == '/'
      let l:project_root = l:project_dir
      break
    endif
  endwhile

  let l:module_name = l:project_dir[len(l:project_root)+1:]
  if !empty(l:module_name)
    return ' -p '.l:module_name
  else
    return ''
  endif
endfunction

function! s:GetJavaProjectDirectory(filepath)
    let buildFile = s:GetBuildFile(a:filepath)
    if strlen(l:buildFile) > 0
        return fnamemodify(l:buildFile, ':h')
    else
        return 0
    endif
endfunction

function! s:GetGradleFilename(dir)
    let l:fn = a:dir . "/build.gradle" " Groovy DSL
    let l:fnf = l:fn . ".kts" " fallback to Kotlin DSL
    let l:fns = a:dir . "/settings.gradle"
    let l:fnsf = l:fns . ".kts"

    if filereadable(expand(l:fn))
        return l:fn
    elseif filereadable(expand(l:fnf))
        return l:fnf
    elseif filereadable(expand(l:fns))
        return l:fns
    elseif filereadable(expand(l:fnsf))
        return l:fnsf
    endif
    return ""
endfunction

function! s:GetFileParentDir(file)
    return fnamemodify(a:file, ':h')
endfunction

function! s:GetBuildFile(pwd)
    if a:pwd ==# "\/"
        return 0
    endif

    let l:gradleFiles = s:GetGradleFilename(a:pwd)

    if strlen(l:gradleFiles) > 0
        return l:gradleFiles
    endif 

    let l:loops = 0
    let l:parent = s:GetFileParentDir(a:pwd)
    let l:maxFuncDepth = 20
    while !(strlen(l:gradleFiles) > 0) && l:loops <= l:maxFuncDepth
        let l:gradleFiles = s:GetGradleFilename(l:parent)
        let l:parent = s:GetFileParentDir(l:parent)
        let l:loops = l:loops + 1
    endwhile

    return l:gradleFiles

endfunction

function! test#java#gradletest#executable() abort
  if findfile('gradlew') ==# 'gradlew'
    return './gradlew test'
  else
    return 'gradle test'
  endif
endfunction

function! s:nearest_test(position) abort
  let l:name = test#base#nearest_test(a:position, g:test#java#patterns)
  let l:nested_class_separator = "$"
  let l:test_separator = "."
  let l:namespace = join(l:name['namespace'] , l:nested_class_separator)
  let l:test = join(l:name['test'] , l:test_separator)
  if empty(l:test)
      return l:namespace
  endif
  return escape(l:namespace . l:test_separator . l:test, '#$')
endfunction
