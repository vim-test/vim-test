if !exists('g:test#rust#cargotest#file_pattern')
  let g:test#rust#cargotest#file_pattern = '\v\.rs$'
endif

function! test#rust#cargotest#test_file(file) abort
  return a:file =~# g:test#rust#cargotest#file_pattern
endfunction

function! test#rust#cargotest#build_position(type, position) abort
  return []
endfunction

function! test#rust#cargotest#build_args(args) abort
  return a:args
endfunction

function! test#rust#cargotest#executable() abort
  return 'cargo test'
endfunction
