if exists('g:loaded_test')
  finish
endif
let g:loaded_test = 1

let g:test#plugin_path = expand('<sfile>:p:h:h')

function! s:extend(source, dict) abort
  for [key, value] in items(a:dict)
    let a:source[key] = get(a:source, key, []) + value
  endfor
endfunction

let g:test#runners = get(g:, 'test#runners', {})
call s:extend(g:test#runners, {
  \ 'Ruby':       ['RSpec', 'Minitest', 'Cucumber'],
  \ 'JavaScript': ['Mocha', 'Jasmine'],
  \ 'Python':     ['PyTest', 'Nose'],
  \ 'Elixir':     ['ExUnit'],
  \ 'Go':         ['GoTest'],
  \ 'Clojure':    ['FireplaceTest'],
  \ 'Shell':      ['Bats'],
  \ 'VimL':       ['VSpec', 'Vader'],
  \ 'Lua':        ['Busted'],
\})

command! -nargs=* -bar TestNearest call test#run('nearest', <q-args>)
command! -nargs=* -bar TestFile    call test#run('file', <q-args>)
command! -nargs=* -bar TestSuite   call test#run('suite', <q-args>)
command!          -bar TestLast    call test#run_last()

for [s:language, s:runners] in items(g:test#runners)
  for s:runner in s:runners
    if exists(':'.s:runner) | continue | endif
    let s:runner_id = tolower(s:language).'#'.tolower(s:runner)
    execute 'command! -bar -nargs=* -complete=file'
          \ s:runner
          \ 'call test#execute("'.s:runner_id.'", split(<q-args>))'
  endfor
endfor
