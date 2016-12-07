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
  if a:type == 'nearest'
    let name = s:nearest_test(a:position)
    if !empty(name)
      return [a:position['file'].' -k '.name]
    else
      return [a:position['file']]
    endif
  elseif a:type == 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#cs#dotnet#build_args(args) abort
  let args = a:args

  if test#base#no_colors()
    let args = ['--color=no'] + args
  endif

  return ['test']
endfunction

function! test#cs#dotnet#executable() abort
  return 'dotnet'
endfunction

function! s:nearest_test(position) abort
  let name = test#base#nearest_test(a:position, g:test#cs#patterns)
  return get(name['test'], 0, '')
endfunction
