source plugin/test.vim

function! Teardown() abort
  bufdo! bdelete!
  unlet! g:test#last_command g:test#last_position
endfunction

function! test#shell(cmd) abort
  let g:test#last_command = a:cmd
endfunction
