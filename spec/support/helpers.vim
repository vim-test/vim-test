let g:test#runner_commands = ['RSpec', 'Minitest', 'FireplaceTest', 'Prove']

runtime! plugin/projectionist.vim
source plugin/test.vim
source spec/support/test/strategy.vim

function! Teardown() abort
  bufdo! bdelete!
  unlet! g:test#last_command g:test#last_position g:test#last_strategy
endfunction
