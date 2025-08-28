let g:test#csharp#patterns = {
  \ 'test':      ['\v^\s*public void (\w+)', '\v^\s*public async void (\w+)', '\v^\s*public async Task (\w+)'],
  \ 'namespace': ['\v^\s*public class (\w+)', '\v^\s*namespace ((\w|\.)+)'],
\}

" Set the default slash to the forward slash
let s:slash = '/'
if (has('win32') || has('win64'))
    let shell = fnamemodify(&shell, ':t')
    if (shell ==? 'cmd.exe' || shell ==? 'powershell')
        let s:slash = '\'
    endif
endif

function! test#csharp#get_project_path(file) abort
  let l:filepath = fnamemodify(a:file, ':p:h')
  let l:project_files = s:get_project_files(l:filepath)
  let l:search_for_csproj = 1

  while len(l:project_files) == 0 && l:search_for_csproj
    let l:filepath_parts = split(l:filepath, s:slash)
    let l:search_for_csproj = len(l:filepath_parts) > 1
    " only want the forward slash at the root dir for non-windows machines
    let l:filepath = substitute(s:slash, '\', '', '').join(l:filepath_parts[0:-2], s:slash)
    let l:project_files = s:get_project_files(l:filepath)
  endwhile

  if len(l:project_files) == 0
    return []
  endif

  return l:project_files[0]
endfunction

function! s:get_project_files(filepath) abort
  return split(glob(a:filepath . s:slash . '*.csproj'), '\n')
endfunction
