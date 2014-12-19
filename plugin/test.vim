if exists('g:loaded_test')
  finish
endif
let g:loaded_test = 1

let g:test#plugin_path = expand('<sfile>:p:h:h')

let g:test#runners  = get(g:, 'test#runners', [])
let g:test#runners += ['RSpec', 'Minitest', 'Cucumber'] " Ruby
let g:test#runners += ['Mocha', 'Jasmine']              " JavaScript
let g:test#runners += ['Nose']                          " Python
let g:test#runners += ['ExUnit']                        " Elixir
let g:test#runners += ['GoTest']                        " Go
let g:test#runners += ['Bats']                          " Shell
let g:test#runners += ['VSpec']                         " VimScript
let g:test#runners += ['Busted']                        " Lua

command! -nargs=* -bar TestNearest call test#run('nearest', <q-args>)
command! -nargs=* -bar TestFile    call test#run('file', <q-args>)
command! -nargs=* -bar TestSuite   call test#run('suite', <q-args>)
command!          -bar TestLast    call test#run_last()

for s:runner in g:test#runners
  execute 'command! -bar -nargs=* -complete=file'
        \ s:runner
        \ 'call test#execute("'.tolower(s:runner).'", split(<q-args>))'
endfor | unlet! s:runner

augroup test
  autocmd!
  autocmd BufLeave *
    \ if test#test_file() |
    \   call test#save_position() |
    \ endif
augroup END
