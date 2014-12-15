source plugin/test.vim

function! Teardown() abort
  unlet! g:test#last_position g:test#last_command
endfunction

function! test#shell(cmd, ...) abort
  let g:test#last_command = a:cmd
endfunction
