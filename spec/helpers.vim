source plugin/test.vim

function! Teardown() abort
  bufdo! bdelete!
  unlet! g:test#last_command g:test#last_position
endfunction

function! LastCommand() abort
  return g:test#last_command.value
endfunction

function! test#strategy#basic(cmd, ...) abort
endfunction

function! test#strategy#vimscript(cmd, ...) abort
endfunction
