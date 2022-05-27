if !exists('g:test#haskell#stacktest#file_pattern')
  let g:test#haskell#stacktest#file_pattern = '\v^(.*spec.*)\c\.hs$'
endif

if !exists('g:test#haskell#stacktest#test_command')
  let g:test#haskell#stacktest#test_command = 'test'
endif

" Returns true if the given file belongs to your test runner
function! test#haskell#stacktest#test_file(file) abort
  return test#haskell#test_file('stacktest', g:test#haskell#stacktest#file_pattern, a:file)
endfunction

" Returns test runner's arguments which will run the current file and/or line
function! test#haskell#stacktest#build_position(type, position) abort
  let l:filename = fnamemodify(a:position['file'], ':t:r')
  let l:file_parent_dir = fnamemodify(a:position['file'], ':p:h')
  let l:package_dir = s:get_nearest_package_dir(l:file_parent_dir)
  let l:project_dir = s:get_nearest_project_dir(l:file_parent_dir)
  let l:package_name_arg = ""
  if strlen(l:package_dir) > 0 && l:package_dir != l:project_dir
    " Multi-package project
    let l:package_name_arg = fnamemodify(l:package_dir, ":t")
  endif

  if a:type ==# 'nearest'
    let l:name = s:nearest_test(a:position)
    let l:module_name = substitute(l:filename, "Spec", "", "")
    if !empty(l:name)
      return s:mk_test_command(l:package_name_arg, l:name)
    elseif !empty(l:module_name)
      return s:mk_test_command(l:package_name_arg, l:module_name)
    endif
  elseif a:type ==# 'file'
    let l:module_name = substitute(l:filename, "Spec", "", "")
    if !empty(l:module_name)
      return s:mk_test_command(l:package_name_arg, l:module_name)
    endif
  endif
  return s:mk_test_command(l:package_name_arg, "")
endfunction

function! test#haskell#stacktest#build_args(args) abort
  return a:args
endfunction

function! test#haskell#stacktest#executable() abort
  return 'stack'
endfunction

function! s:nearest_test(position) abort
  let name = test#base#nearest_test(a:position, g:test#haskell#patterns)
  return escape(escape(join(name['test'], ""), '"'), "'")
endfunction

" Returns the stack test command with --test-arguments '-m \"<hspec_match>"\.
function! s:mk_test_command(package_name_arg, hspec_match)
  let l:test_args = ""
  if !empty(a:hspec_match)
    let l:test_args = "--test-arguments '-m \"" . a:hspec_match . "\"'"
  end
  return [g:test#haskell#stacktest#test_command, a:package_name_arg, l:test_args]
endfunction

" Returns the nearest project directory containing stack.yaml.
" Returns 0 if no directory is found.
function!s:get_nearest_project_dir(pwd)
  return s:get_nearest_parent_dir(a:pwd, "stack.yaml")
endfunction

" Returns the nearest package directory containing package.yaml.
" Returns 0 if no directory is found.
function!s:get_nearest_package_dir(pwd)
  return s:get_nearest_parent_dir(a:pwd, "package.yaml")
endfunction

" Recursively search pwd and its parent directories until file_name is found.
" Returns the path to the directory containing file_name.
" Returns 0 if no directory is found.
function! s:get_nearest_parent_dir(pwd, file_name)
  if a:pwd ==# "\/"
    return 0
  else
    let l:file_path = a:pwd . "/" . a:file_name
    if filereadable(expand(l:file_path))
      return a:pwd
    else
      let l:parent = fnamemodify(a:pwd, ':h')
      return s:get_nearest_parent_dir(l:parent, a:file_name)
    endif
  endif
endfunction
