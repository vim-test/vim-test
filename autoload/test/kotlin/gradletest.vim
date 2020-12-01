if !exists('g:test#kotlin#gradletest#file_pattern')
  let g:test#kotlin#gradletest#file_pattern = '\v([Tt]est.*|.*[Tt]est(s|Case)?)\.kt$'
endif

function! test#kotlin#gradletest#test_file(file) abort
  return a:file =~? g:test#kotlin#gradletest#file_pattern
endfunction

function! test#kotlin#gradletest#build_position(type, position) abort
  let filename = fnamemodify(a:position['file'], ':t:r')
  let modulename = s:get_module(a:position['file'])
  if a:type ==# 'nearest'
    let name = s:nearest_test(a:position)
    if !empty(name)
      return ['--tests ' . name . modulename]
    else
      return ['--tests ' . filename . modulename]
    endif
  elseif a:type ==# 'file'
    return ['--tests ' . filename . modulename]
  else
    return [modulename]
  endif
endfunction

function! test#kotlin#gradletest#build_args(args) abort
  return a:args
endfunction

function! s:get_module(filepath)
  let project_dir = s:GetKotlinProjectDirectory(a:filepath)
  let l:parent = fnamemodify(project_dir, ':p:h:h')
  if filereadable(l:parent . '/build.gradle') " check if the parent dir has build.gradle
      return ' -p ' . project_dir
  else
      return ''
  endif
endfunction

function! s:GetKotlinProjectDirectory(filepath)
    let buildFile = s:GetBuildFile(a:filepath)
    if strlen(l:buildFile) > 0
        return fnamemodify(l:buildFile, ':h')
    else
        return 0
    endif
endfunction

function! s:GetBuildFile(pwd)
    if a:pwd ==# '\/'
        return 0
    else
        let l:fn = a:pwd . '/build.gradle'

        if filereadable(expand(l:fn))
            return l:fn
        else
            let l:parent = fnamemodify(a:pwd, ':h')
            return s:GetBuildFile(l:parent)
        endif
    endif
endfunction

function! test#kotlin#gradletest#executable() abort
  if findfile('gradlew') ==# 'gradlew'
    return './gradlew test'
  else
    return 'gradle test'
  endif
endfunction

function! s:nearest_test(position) abort
  let name = test#base#nearest_test(a:position, g:test#kotlin#patterns)
  return join(name['namespace'] + name['test'], '.')
endfunction
