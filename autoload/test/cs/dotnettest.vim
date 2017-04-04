if !exists('g:test#cs#dotnettest#file_pattern')
  let g:test#cs#dotnettest#file_pattern = '\v^.*[Tt]ests\.cs$'
endif

function! test#cs#dotnettest#test_file(file) abort
  return a:file =~? g:test#cs#dotnettest#file_pattern
endfunction

function! test#cs#dotnettest#build_position(type, position) abort
  let file = a:position['file']
  let filename = fnamemodify(file, ':t:r')
  let filedir = fnamemodify(file, ':p:h')
  let projfiles = split(glob(filedir . '/*.csproj'), '\n')
  let search_for_csproj = 1

  while len(projfiles) == 0 && search_for_csproj
    let filedirparts = split(filedir, '/') 
    let search_for_csproj = len(filedir) > 1
    let filedir = '/'.join(filedirparts[0:-2], '/')
    let projfiles = split(glob(filedir . '/*.csproj'), '\n')
  endwhile

  if len(projfiles) == 0
    throw 'Unable to find .csproj file, a .csproj file is required to make use of the `dotnet test` command.'
  endif

  let projectPath = projfiles[0]

  if a:type == 'nearest'
    let name = s:nearest_test(a:position)
    if !empty(name)
      return [name, projectPath]
    else
      return [filename, projectPath]
    endif
  elseif a:type == 'file'
    return [filename, projectPath]
  else
    return ['*', projectPath]
  endif
endfunction

function! test#cs#dotnettest#build_args(args) abort
  let filter = ''
  if a:args[0] != '*'
    let filter = ' --filter FullyQualifiedName\~'.a:args[0]
  endif
  let args = ['test ', a:args[1], filter]
  return [join(args, "")]
endfunction

function! test#cs#dotnettest#executable() abort
  return 'dotnet'
endfunction

function! s:nearest_test(position) abort
  let name = test#base#nearest_test(a:position, g:test#cs#patterns)
  return join(name['namespace'] + name['test'], '.')
endfunction
