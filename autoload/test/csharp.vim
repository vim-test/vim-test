let g:test#csharp#patterns = {
  \ 'test':      ['\v^\s*public void (\w+)', '\v^\s*public async void (\w+)'],
  \ 'namespace': ['\v^\s*public class (\w+)', '\v^\s*namespace ((\w|\.)+)'],
\}

function! test#csharp#get_project_path(file) abort
  let l:filepath = fnamemodify(a:file, ':p:h')
  let l:project_files = split(glob(l:filepath . '/*.csproj'), '\n')
  let l:search_for_csproj = 1

  while len(l:project_files) == 0 && l:search_for_csproj
    let l:filepath_parts = split(l:filepath, '/') 
    let l:search_for_csproj = len(l:filepath_parts) > 1
    let l:filepath = '/'.join(l:filepath_parts[0:-2], '/')
    let l:project_files = split(glob(l:filepath . '/*.csproj'), '\n')
  endwhile

  if len(l:project_files) == 0
    throw 'Unable to find .csproj file, a .csproj file is required to make use of the `dotnet test` command.'
  endif

  return l:project_files[0]
endfunction
