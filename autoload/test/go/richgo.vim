if !exists('g:test#go#richgo#file_pattern')
  let g:test#go#richgo#file_pattern = '\v[^_].*_test\.go$'
endif

function! test#go#richgo#test_file(file) abort
  return test#go#test_file('richgo', g:test#go#richgo#file_pattern, a:file)
endfunction

function! test#go#richgo#build_position(type, position) abort
  return test#go#gotest#build_position(a:type, a:position)
endfunction

function! test#go#richgo#build_args(args) abort
  return test#go#gotest#build_args(a:args)
endfunction

function! test#go#richgo#executable() abort
  return 'richgo test'
endfunction
