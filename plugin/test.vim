if exists('g:loaded_test')
  finish
endif
let g:loaded_test = 1

let g:test#plugin_path = expand('<sfile>:p:h:h')

let g:test#default_runners = {
  \ '_Generic':   ['VimTestJson'],
  \ 'CSharp':     ['Xunit', 'DotnetTest'],
  \ 'Clojure':    ['FireplaceTest', 'LeinTest'],
  \ 'Crystal':    ['CrystalSpec'],
  \ 'Cpp':        ['Catch2'],
  \ 'Dart':       ['DartTest', 'FlutterTest'],
  \ 'Elixir':     ['ExUnit', 'ESpec'],
  \ 'Elm':        ['ElmTest'],
  \ 'Erlang':     ['CommonTest', 'EUnit', 'PropEr'],
  \ 'Go':         ['GoTest', 'Ginkgo', 'RichGo', 'Delve'],
  \ 'Groovy':     ['MavenTest', 'GradleTest'],
  \ 'Haskell':    ['StackTest', 'CabalTest'],
  \ 'Java':       ['MavenTest', 'GradleTest'],
  \ 'JavaScript': ['Ava', 'CucumberJS', 'DenoTest', 'Intern', 'TAP', 'Teenytest', 'Karma', 'Lab', 'Mocha',  'NgTest', 'Nx', 'Jasmine', 'Jest', 'ReactScripts', 'WebdriverIO', 'Cypress', 'VueTestUtils', 'Playwright', 'Vitest', 'Ember', 'NodeTest', 'BunTest'],
  \ 'Kotlin':     ['GradleTest'],
  \ 'Lua':        ['Busted'],
  \ 'Mint':       ['MintTest'],
  \ 'Nim':        ['UnitTest'],
  \ 'PHP':        ['Codeception', 'Dusk', 'Pest', 'PHPUnit', 'Behat', 'PHPSpec', 'Kahlan', 'Peridot'],
  \ 'Perl':       ['Prove'],
  \ 'Python':     ['Behave', 'DjangoTest', 'PyTest', 'PyUnit', 'Nose', 'Nose2', 'Mamba'],
  \ 'Racket':     ['RackUnit'],
  \ 'Ruby':       ['Rails', 'M', 'Minitest', 'RSpec', 'Cucumber', 'TestBench'],
  \ 'Rust':       ['CargoNextest', 'CargoTest'],
  \ 'Scala':      ['SbtTest', 'BloopTest'],
  \ 'Shell':      ['Bats', 'ShellSpec'],
  \ 'Swift':      ['SwiftPM'],
  \ 'VimL':       ['Themis', 'VSpec', 'Vader', 'Testify', 'Vroom'],
  \ 'Zig':        ['ZigTest'],
  \ 'Gleam':      ['GleamTest'],
  \ 'Robot':      ['RobotFramework'],
\}

let g:test#custom_strategies = get(g:, 'test#custom_strategies', {})
let g:test#custom_transformations = get(g:, 'test#custom_transformations', {})
let g:test#runner_commands = get(g:, 'test#runner_commands', [])

command! -nargs=* -bar TestNearest call test#run('nearest', split(<q-args>))
command! -nargs=* -bar -complete=file
      \                TestFile    call test#run('file', split(<q-args>))
command! -nargs=* -bar TestClass   call test#run('class', split(<q-args>))
command! -nargs=* -bar TestSuite   call test#run('suite', split(<q-args>))
command! -nargs=* -bar TestLast    call test#run_last(split(<q-args>))
command!          -bar TestVisit   call test#visit()

for [s:language, s:runners] in items(test#get_runners())
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
