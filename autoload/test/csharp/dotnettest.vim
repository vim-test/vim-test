if !exists('g:test#csharp#dotnettest#file_pattern')
  let g:test#csharp#dotnettest#file_pattern = '\v\.cs$'
endif

function! test#csharp#dotnettest#test_file(file) abort
  if fnamemodify(a:file, ':t') =~# g:test#csharp#dotnettest#file_pattern
    if exists('g:test#csharp#runner')
      return g:test#csharp#runner ==# 'dotnettest'
    endif
    return 1
  endif
endfunction

function! test#csharp#dotnettest#build_position(type, position) abort
  let file = a:position['file']
  let filename = fnamemodify(file, ':t:r')
  let project_path = test#csharp#get_project_path(file)

  if a:type ==# 'nearest'
    let name = s:nearest_test(a:position)
    if !empty(name)
      return [project_path, '--filter', 'FullyQualifiedName\~' . name]
    else
      return [project_path, '--filter', 'FullyQualifiedName\~' . filename]
    endif
  elseif a:type ==# 'file'
    return [project_path,  '--filter', 'FullyQualifiedName\~' . filename]
  else
    return [project_path]
  endif
endfunction

function! test#csharp#dotnettest#build_args(args) abort
  let args = a:args
  return [join(args, ' ')]
endfunction

function! test#csharp#dotnettest#executable() abort
  return 'dotnet test'
endfunction

function! s:nearest_test(position) abort
  let name = test#base#nearest_test(a:position, g:test#csharp#patterns)
  return join(name['namespace'] + name['test'], '.')
endfunction
