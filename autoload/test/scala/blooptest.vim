" Returns true if the given file belongs to your test runner
if !exists('g:test#scala#blooptest#file_pattern')
  let g:test#scala#blooptest#file_pattern = '\v^(.*spec.*|.*test.*|.*suite.*)\c\.scala$'
endif

function! test#scala#blooptest#test_file(file) abort
  return test#scala#test_file('blooptest', g:test#scala#blooptest#file_pattern, a:file)
endfunction

 " Returns test runner's arguments which will run the current file and/or line
function! test#scala#blooptest#build_position(type, position) abort
  let filename = fnamemodify(a:position['file'], ':t:r')

  " set custom project_name with `let g:test#scala#blooptest#project_name`
  let s:project_name = get(g:, 'test#scala#blooptest#project_name', s:get_bloop_project())

   if a:type ==# 'nearest'
    let name = s:nearest_test(a:position)
    if !empty(name)
      return ['test ' . s:project_name . ' -o "*' . filename . '" -- -z ' . name]
    else
      return ['test ' . s:project_name . ' -o "*' . filename . '"']
    endif
  elseif a:type ==# 'file'
    return ['test ' . s:project_name . ' -o "*' . filename . '"']
  else
    return ['test ' . s:project_name]
  endif
endfunction

function! test#scala#blooptest#build_args(args) abort
  return a:args
endfunction

function! test#scala#blooptest#test_file(file) abort
  let current_file = fnamemodify(a:file, ':t')
  return current_file =~? g:test#scala#blooptest#file_pattern
endfunction

function! test#scala#blooptest#executable() abort
  return 'bloop'
endfunction

function! s:nearest_test(position) abort
  let name = test#base#nearest_test(a:position, g:test#scala#patterns)
  return join(name['test'], "")
endfunction

function! s:get_bloop_project() abort
  return system("echo $(bloop projects) | cut -d\" \" -f 1")
endfunction
