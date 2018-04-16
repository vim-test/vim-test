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

let g:runner_heuristics = {
  \  "bin/rspec" : {
  \    "spec/*_spec.rb" : {
  \      "runner" : "bin/rspec"
  \    },
  \  },
  \  ".zeus.sock" : {
  \    "spec/*_spec.rb" : {
  \      "runner" : "zeus rspec"
  \    },
  \  },
  \  "Gemfile" : {
  \    "spec/*_spec.rb" : {
  \      "runner" : "bundle exec rspec"
  \    },
  \  },
  \  "!bin/rspec&!.zeus.sock&!Gemfile" : {
  \    "spec/*_spec.rb" : {
  \      "runner" : "rspec"
  \    },
  \  }
  \}

function! s:has(root, file) abort
  let file = matchstr(a:file, '[^!].*')
  if file =~# '\*'
    let found = !empty(glob(a:root . '/' . file))
  elseif file =~# '/$'
    let found = isdirectory(a:root . '/' . file)
  else
    let found = filereadable(a:root . '/' . file)
  endif
  return a:file =~# '^!' ? !found : found
endfunction

autocmd User ProjectionistDetect
  \  let root = getcwd() |
  \  for [key, value] in items(g:runner_heuristics) |
  \    for test in split(key, '|') |
  \      if empty(filter(split(test, '&'), '!s:has(root, v:val)')) |
  \        call projectionist#append(root, value) |
  \        break |
  \      endif |
  \    endfor |
  \  endfor

let g:test#runners = get(g:, 'test#runners', {})
call s:extend(g:test#runners, {
  \ 'Generic':    ['Projectionist'],
  \ 'Ruby':       ['Rails', 'M', 'Minitest', 'Cucumber'],
  \ 'JavaScript': ['Ava', 'CucumberJS', 'Intern', 'TAP', 'Karma', 'Lab', 'Mocha', 'Jasmine', 'Jest', 'WebdriverIO'],
  \ 'Python':     ['DjangoTest', 'PyTest', 'PyUnit', 'Nose', 'Nose2'],
  \ 'Elixir':     ['ExUnit', 'ESpec'],
  \ 'Elm':        ['ElmTest'],
  \ 'Erlang':     ['CommonTest'],
  \ 'Go':         ['GoTest', 'Ginkgo'],
  \ 'Rust':       ['CargoTest'],
  \ 'Clojure':    ['FireplaceTest'],
  \ 'CSharp':     ['Xunit', 'DotnetTest'],
  \ 'Shell':      ['Bats'],
  \ 'Swift':      ['SwiftPM'],
  \ 'VimL':       ['Themis', 'VSpec', 'Vader'],
  \ 'Lua':        ['Busted'],
  \ 'PHP':        ['Codeception', 'Dusk', 'PHPUnit', 'Behat', 'PHPSpec', 'Kahlan', 'Peridot'],
  \ 'Perl':       ['Prove'],
  \ 'Racket':     ['RackUnit'],
  \ 'Java':       ['MavenTest'],
  \ 'Crystal':    ['CrystalSpec'],
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
