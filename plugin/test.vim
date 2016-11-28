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
  \ 'Ruby':       ['M', 'Minitest', 'RSpec', 'Cucumber'],
  \ 'JavaScript': ['Intern', 'TAP', 'Karma', 'Mocha', 'Jasmine'],
  \ 'Python':     ['DjangoTest', 'PyTest', 'Nose'],
  \ 'Elixir':     ['ExUnit', 'ESpec'],
  \ 'Go':         ['GoTest'],
  \ 'Rust':       ['CargoTest'],
  \ 'Clojure':    ['FireplaceTest'],
  \ 'Shell':      ['Bats'],
  \ 'VimL':       ['VSpec', 'Vader'],
  \ 'Lua':        ['Busted'],
  \ 'PHP':        ['Codeception', 'PHPUnit', 'Behat', 'PHPSpec'],
  \ 'Perl':       ['Prove'],
  \ 'Java':       ['MavenTest'],
\})

let g:test#custom_strategies = get(g:, 'test#custom_strategies', {})
let g:test#custom_transformations = get(g:, 'test#custom_transformations', {})
let g:test#runner_commands = get(g:, 'test#runner_commands', [])

command! -nargs=* -bar TestNearest call test#run('nearest', split(<q-args>))
command! -nargs=* -bar TestFile    call test#run('file', split(<q-args>))
command! -nargs=* -bar TestSuite   call test#run('suite', split(<q-args>))
command! -nargs=* -bar TestLast    call test#run_last(split(<q-args>))
command!          -bar TestVisit   call test#visit()

for [s:language, s:runners] in items(g:test#runners)
  for s:runner in s:runners
    if index(g:test#runner_commands, s:runner) != -1
      if exists(':'.s:runner) | continue | endif
      let s:runner_id = tolower(s:language).'#'.tolower(s:runner)
      execute 'command! -bar -nargs=* -complete=file'
            \ s:runner
            \ 'call test#execute("'.s:runner_id.'", split(<q-args>))'
    endif
  endfor
endfor

if &autochdir
  let g:test#project_root = getcwd()
endif
