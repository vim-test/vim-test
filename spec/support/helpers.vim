let g:test#runner_commands = ['RSpec', 'Minitest', 'FireplaceTest', 'Prove']

source plugin/test.vim

" don't execute any shell commands
function! test#strategy#basic(cmd)
endfunction

" don't execute any VimScript commands
function! test#strategy#vimscript(cmd)
endfunction

function! Teardown() abort
  bufdo! bdelete!
  unlet! g:test#last_command g:test#last_position
endfunction
