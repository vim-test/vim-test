if !exists('g:test#java#gradletest#file_pattern')
  let g:test#java#gradletest#file_pattern = '\v([Tt]est.*|.*[Tt]est(s|Case)?)\.java$'
endif

function! test#java#gradletest#test_file(file) abort
  return a:file =~? g:test#java#gradletest#file_pattern
    \ && exists('g:test#java#runner')
    \ && g:test#java#runner ==# 'gradletest'
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
  let project_dir = s:GetJavaProjectDirectory(a:filepath)
  let l:module_name = fnamemodify(project_dir, ':t')
  let l:parent = fnamemodify(project_dir, ':p:h:h')
  if filereadable(l:parent. "/build.gradle") " check if the parent dir has build.gradle
      return ' -p '. module_name
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

function! s:GetBuildFile(pwd)
    if a:pwd ==# "\/"
        return 0
    else
        let l:fn = a:pwd . "/build.gradle"

        if filereadable(expand(l:fn))
            return l:fn
        else
            let l:parent = fnamemodify(a:pwd, ':h')
            return s:GetBuildFile(l:parent)
        endif
    endif
endfunction

function! test#java#gradletest#executable() abort
  return 'gradle test'
endfunction

function! s:nearest_test(position) abort
  let name = test#base#nearest_test(a:position, g:test#java#patterns)
  return join(name['namespace'] + name['test'], '.')
endfunction
