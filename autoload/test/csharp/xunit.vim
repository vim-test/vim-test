if !exists('g:test#csharp#xunit#file_pattern')
  let g:test#csharp#xunit#file_pattern = '\v\.cs$'
endif

function! test#csharp#xunit#test_file(file) abort
  if fnamemodify(a:file, ':t') =~# g:test#csharp#xunit#file_pattern
    if exists('g:test#csharp#runner')
      return g:test#csharp#runner ==# 'xunit'
    else
      return s:is_using_dotnet_xunit_cli(a:file)
          \ && (search('using Xunit', 'n') > 0)
          \ && (search('[(Fact|Theory).*]', 'n') > 0)
    endif
  endif
endfunction

function! test#csharp#xunit#build_position(type, position) abort
  let l:found_nearest = 0
  if a:type ==# 'nearest'
    let l:found_nearest = 1
    let l:n = test#base#nearest_test(a:position, g:test#csharp#patterns)
    let l:fully_qualified_name = join(l:n['namespace'] + l:n['test'], '.')
    if !empty(l:fully_qualified_name)
      return [s:test_command(l:n), l:fully_qualified_name]
    endif
  endif
  if a:type ==# 'file' || l:found_nearest
    let l:position = a:position
    let l:position['line'] = '$'
    let l:n = test#base#nearest_test(l:position, g:test#csharp#patterns)

    " Discard the test name and use the name space with the test class name
    let l:n['test'] = []
    let l:fully_qualified_name = join(l:n['namespace'][:1], '.')

    if !empty(l:fully_qualified_name)
      return [s:test_command(l:n), l:fully_qualified_name]
    else
      throw 'Could not find any tests.'
    endif
  endif

  return []
endfunction

function! test#csharp#xunit#build_args(args) abort
  let l:args = a:args
  call insert(l:args, '-nologo')
  return [join(l:args, ' ')]
endfunction

function! test#csharp#xunit#executable() abort
  return 'dotnet xunit'
endfunction

function! s:test_command(name) abort
  if !empty(a:name['test'])
    return '-method'
  elseif len(a:name['namespace']) > 1
    return '-class'
  else
    return '-namespace'
  endif
endfunction

function! s:is_using_dotnet_xunit_cli(file) abort
  let l:project_path = test#csharp#get_project_path(a:file)
  return filereadable(l:project_path) 
      \ && match(
          \ readfile(l:project_path), 
          \ 'DotNetCliToolReference.*dotnet-xunit')
endfunction
