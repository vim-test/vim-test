if exists('g:loaded_test')
  finish
endif
let g:loaded_test = 1

let g:test#plugin_path = expand('<sfile>:p:h:h')

command! -nargs=* -bar TestNearest call test#run('nearest', <q-args>)
command! -nargs=* -bar TestFile    call test#run('file', <q-args>)
command! -nargs=* -bar TestSuite   call test#run('suite', <q-args>)
command!          -bar TestLast    call test#run_last()

for runner in g:test#runners
  execute 'command! -bar -nargs=* -complete=file'
        \ runner
        \ 'call test#execute("'.tolower(runner).'", split(<q-args>))'
endfor

augroup test
  autocmd!
  autocmd BufLeave *
    \ if test#test_file() |
    \   call test#save_position() |
    \ endif
augroup END
