if !exists('g:test#csharp#dotnettest#file_pattern')
  let g:test#csharp#dotnettest#file_pattern = '\.cs$'
endif

function! test#csharp#dotnettest#test_file(file) abort
  return a:file =~? g:test#csharp#dotnettest#file_pattern
endfunction

function! test#csharp#dotnettest#build_position(type, position) abort
  let file = a:position['file']
  let filename = fnamemodify(file, ':t:r')
  let filepath = fnamemodify(file, ':p:h')
  let project_files = split(glob(filepath . '/*.csproj'), '\n')
  let search_for_csproj = 1

  while len(project_files) == 0 && search_for_csproj
    let filepath_parts = split(filepath, '/') 
    let search_for_csproj = len(filepath_parts) > 1
    let filepath = '/'.join(filepath_parts[0:-2], '/')
    let project_files = split(glob(filepath . '/*.csproj'), '\n')
  endwhile

  if len(project_files) == 0
    throw 'Unable to find .csproj file, a .csproj file is required to make use of the `dotnet test` command.'
  endif

  let project_path = project_files[0]

  if a:type == 'nearest'
    let name = s:nearest_test(a:position)
    if !empty(name)
      return [name, project_path]
    else
      return [filename, project_path]
    endif
  elseif a:type == 'file'
    return [filename, project_path]
  else
    return ['*', project_path]
  endif
endfunction

function! test#csharp#dotnettest#build_args(args) abort
  let filter = ''
  if a:args[0] != '*'
    let filter = ' --filter FullyQualifiedName\~'.a:args[0]
  endif
  let args = [a:args[1], filter]
  return [join(args, "")]
endfunction

function! test#csharp#dotnettest#executable() abort
  return 'dotnet test'
endfunction

function! s:nearest_test(position) abort
  let name = test#base#nearest_test(a:position, g:test#csharp#patterns)
  return join(name['namespace'] + name['test'], '.')
endfunction
