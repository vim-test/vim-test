if !exists('g:test#cs#dotnet#file_pattern')
  let g:test#cs#dotnet#file_pattern = '^.*\.cs$'
endif

function! test#cs#dotnet#test_file(file) abort
  if fnamemodify(a:file, ':t') =~# g:test#cs#dotnet#file_pattern
    if exists('g:test#cs#runner')
      return g:test#cs#runner == 'dotnet'
    else
      return executable('dotnet')
    endif
  endif
endfunction

function! test#cs#dotnet#build_position(type, position) abort
  return []
endfunction

function! test#cs#dotnet#build_args(args) abort
  return ['test']
endfunction

function! test#cs#dotnet#executable() abort
  return 'dotnet'
endfunction
