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
  let name = test#base#nearest_test(a:position, g:test#csharp#patterns)
  let namespace = join(name['namespace'], '.')
  let test_name = join(name['test'], '.')
  let nearest_test = join([namespace, test_name], '.')

  if a:type ==# 'nearest'
    if !empty(test_name)
      return [project_path, '--filter', 'FullyQualifiedName=' . nearest_test]
    else
      if !empty(namespace)
        return [project_path, '--filter', 'FullyQualifiedName~' . namespace]
      else
        return [project_path]
      endif
    endif
  elseif a:type ==# 'file'
    throw 'file tests is not supported for dotnettest'
  elseif a:type ==# 'suite'
    if !empty(project_path)
      return [project_path]
    else
      return []
    endif
  endif
endfunction

function! test#csharp#dotnettest#build_args(args) abort
  let args = a:args
  return [join(args, ' ')]
endfunction

function! test#csharp#dotnettest#executable() abort
  return 'dotnet test'
endfunction
