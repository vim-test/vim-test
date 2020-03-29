if !exists('g:test#javascript#ngtest#file_pattern')
  let g:test#javascript#ngtest#file_pattern = '\v(test|spec)\.(js|jsx|ts|tsx)$'
endif

function! test#javascript#ngtest#test_file(file) abort
  return a:file =~# g:test#javascript#ngtest#file_pattern
    \ && test#javascript#has_package('@angular/cli')
endfunction

function! test#javascript#ngtest#build_args(args) abort
  return a:args
endfunction

function! test#javascript#ngtest#build_position(type, position) abort
  return []
endfunction

function! test#javascript#ngtest#executable() abort
  return 'ng test'
endfunction
