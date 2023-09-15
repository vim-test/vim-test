if !exists('g:test#javascript#nx#file_pattern')
  let g:test#javascript#nx#file_pattern = '\v(__tests__/.*|(spec|test))\.(js|jsx|coffee|ts|tsx)$'
endif

function! test#javascript#nx#test_file(file) abort
  if a:file =~# g:test#javascript#nx#file_pattern
      if exists('g:test#javascript#runner')
          return g:test#javascript#runner ==# 'nx'
      else
        return test#javascript#has_package('nx')
      endif
  endif
endfunction

function! test#javascript#nx#build_position(type, position) abort
  let project = ''

  let l:project_json = findfile('project.json', '.;')
  if filereadable(project_json)
    let l:project_json_file = readfile(project_json)
    if exists('*json_decode')
      let project = json_decode(join(project_json_file, ''))['name']
    endif
  elseif filereadable('workspace.json')
    let l:workpaces = readfile('workspace.json')
    if exists('*json_decode')
      let l:projects = json_decode(join(workpaces, ''))['projects']
      for [key, value] in items(projects)
        if stridx(a:position['file'], value) >= 0
          let project = key
          break
        endif
      endfor
    endif
  endif

  if a:type ==# 'nearest'
    let name = s:nearest_test(a:position)
    if !empty(name)
      let name = '-t '.shellescape(name, 1)
    endif
    return [project, name, '--test-file', a:position['file']]
  elseif a:type ==# 'file'
    return [project, '--test-file', a:position['file']]
  else
    return [project]
  endif
endfunction

let s:yarn_command = '\<yarn\>'
function! test#javascript#nx#build_args(args) abort
  if exists('g:test#javascript#nx#executable')
    \ && g:test#javascript#nx#executable =~# s:yarn_command
    return filter(a:args, 'v:val != "--"')
  else
    return a:args
  endif
endfunction

function! test#javascript#nx#executable() abort
  if exists('g:test#javascript#nx#project')
    if filereadable('node_modules/.bin/nx')
      return 'node_modules/.bin/nx test ' . g:test#javascript#nx#project
    else
      return 'nx test ' . g:test#javascript#nx#project
    endif
  endif
  if filereadable('node_modules/.bin/nx')
    return 'node_modules/.bin/nx test'
  else
    return 'nx test'
  endif
endfunction

function! s:nearest_test(position) abort
  let name = test#base#nearest_test(a:position, g:test#javascript#patterns)
  return (len(name['namespace']) ? '^' : '') .
       \ test#base#escape_regex(join(name['namespace'] + name['test'])) .
       \ (len(name['test']) ? '$' : '')
endfunction
