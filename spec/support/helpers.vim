let g:test#runner_commands = ['RSpec', 'Minitest', 'FireplaceTest', 'Prove']

if has('win32') || has('win64')
  set shellslash
endif

source plugin/test.vim
source spec/support/test/strategy.vim

function! Teardown() abort
  bufdo! bdelete!
  unlet! g:test#last_command g:test#last_position g:test#last_strategy
endfunction
