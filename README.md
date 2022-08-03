# test.vim

A Vim wrapper for running tests on different granularities.

<img alt="usage overview" src="https://github.com/vim-test/vim-test/blob/master/screenshots/granularity.gif" width=770 height=503>

## Features

* Zero dependencies
* Zero configuration required (it Does the Right Thing™, see [**Philosophy**](https://github.com/vim-test/vim-test/wiki))
* Wide range of test runners which are automagically detected
* **Polyfills** for nearest tests (by [constructing regexes](#commands))
* Wide range of execution environments ("[strategies](#strategies)")
* Fully customized CLI options configuration
* Extendable with new runners and strategies

Test.vim consists of a core which provides an abstraction over running any kind
of tests from the command-line. Concrete test runners are then simply plugged
in, so they all work in the same unified way. Currently the following test
runners are supported:

|       Language | Test Runners                                                                                                       | Identifiers                                                                                                                                  |
| -------------: | :----------------------------------------------------------------------------------------------------------------- | :------------------------------------------------------------------------------------------------------------------------------------------- |
|         **C#** | .NET                                                                                                               | `xunit`, `dotnettest`                                                                                                                        |
|         **C++** | CTest,Make                                                                                                               | `ctest`, `make`                                                                                                                        |
|    **Clojure** | Fireplace.vim                                                                                                      | `fireplacetest`                                                                                                                              |
|    **Crystal** | Crystal                                                                                                            | `crystalspec`                                                                                                                                |
|       **Dart** | Dart Test, Flutter Test                                                                                            | `darttest`, `fluttertest`
|     **Elixir** | ESpec, ExUnit                                                                                                      | `espec`, `exunit`                                                                                                                            |
|        **Elm** | elm-test                                                                                                           | `elmtest`                                                                                                                                    |
|     **Erlang** | CommonTest, EUnit, PropEr                                                                                          | `commontest`, `eunit`, `proper`                                                                                                              |
|         **Go** | Ginkgo, Go, Rich-Go, Delve                                                                                         | `ginkgo`, `gotest`, `richgo`, `delve`                                                                                                        |
|     **Groovy** | Maven, Gradle                                                                                                      | `maventest`, `gradletest`                                                                                                                    |
|    **Haskell** | stack                                                                                                              | `stacktest`                                                                                                                                  |
|       **Java** | Maven, Gradle (Groovy and Kotlin DSL)                                                                              | `maventest`, `gradletest`                                                                                                                    |
| **JavaScript** | Ava, Cucumber.js, Cypress, Deno, Intern, Jasmine, Jest, Karma, Lab, Mocha, ng test, NX, Playwright, ReactScripts, TAP, WebdriverIO | `ava`, `cucumberjs`, `cypress`, `deno`, `intern`, `jasmine`, `jest`, `karma`, `lab`, `mocha`, `ngtest` , `nx`, `playwright`, `reactscripts`, `tap`, `webdriverio`, `vue-test-utils`|
|     **Kotlin** | Gradle (Groovy and Kotlin DSL)                                                                                     | `gradletest`                                                                                                                                 |
|        **Lua** | Busted                                                                                                             | `busted`                                                                                                                                     |
|       **Mint** | Mint                                                                                                               | `minttest`                                                                                                                                   |
|        **PHP** | Behat, Codeception, Kahlan, Peridot, Pest, PHPUnit, Sail, PHPSpec, Dusk                                            | `behat`, `codeception`, `dusk`, `kahlan`, `peridot`, `phpunit`, `sail`, `phpspec`, `pest`                                                    |
|       **Perl** | Prove                                                                                                              | `prove`                                                                                                                                      |
|     **Python** | Behave, Django, Mamba, Nose, Nose2, PyTest, PyUnit                                                                 | `behave`, `djangotest`, `djangonose`, `mamba`, `nose`, `nose2`, `pytest`, `pyunit`                                                           |
|     **Racket** | RackUnit                                                                                                           | `rackunit`                                                                                                                                   |
|       **Ruby** | Cucumber, [M], [Minitest][minitest], Rails, RSpec, TestBench                                                       | `cucumber`, `m`, `minitest`, `rails`, `rspec`, `testbench`                                                                                   |
|       **Rust** | Cargo                                                                                                              | `cargotest`                                                                                                                                  |
|      **Scala** | SBT, Bloop                                                                                                         | `sbttest`, `blooptest`                                                                                                                       |
|      **Shell** | Bats, ShellSpec                                                                                                    | `bats`, `shellspec`                                                                                                                          |
|      **Swift** | Swift Package Manager                                                                                              | `swiftpm`                                                                                                                                    |
|  **VimScript** | Vader.vim, Vroom, VSpec, Themis, Testify                                                                           | `vader`, `vroom`, `vspec`, `themis`, `testify`                                                                                               |

## Setup

Using [vim-plug](https://github.com/junegunn/vim-plug), add
```vim
Plug 'vim-test/vim-test'
```
to your `.vimrc` file (see vim-plug documentation for where), and run `:PlugInstall`.

Add your preferred mappings to your `.vimrc` file:

```vim
nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>T :TestFile<CR>
nmap <silent> <leader>a :TestSuite<CR>
nmap <silent> <leader>l :TestLast<CR>
nmap <silent> <leader>g :TestVisit<CR>
```

| Command          | Description                                                                                                                                                                                                                                                                            |
| :--------------  | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  |
| `:TestNearest`   | In a test file runs the test nearest to the cursor, otherwise runs the last nearest test. In test frameworks that don't support line numbers it will **polyfill** this functionality with [regexes](#commands).                                                                        |
| `:TestFile`      | In a test file runs all tests in the current file, otherwise runs the last file tests.                                                                                                                                                                                                 |
| `:TestSuite`     | Runs the whole test suite (if the current file is a test file, runs that framework's test suite, otherwise determines the test framework from the last run test).                                                                                                                      |
| `:TestLast`      | Runs the last test.                                                                                                                                                                                                                                                                    |
| `:TestVisit`     | Visits the test file from which you last run your tests (useful when you're trying to make a test pass, and you dive deep into application code and close your test buffer to make more space, and once you've made it pass you want to go back to the test file to write more tests). |

## Strategies

Test.vim can run tests using different execution environments called
"strategies". To use a specific strategy, assign it to a variable:

```vim
" make test commands execute using dispatch.vim
let test#strategy = "dispatch"
```

| Strategy                        | Identifier                                                  | Description                                                                                                                                                       |
| :-----:                         | :-----:                                                     | :----------                                                                                                                                                       |
| **Basic**&nbsp;(default)        | `basic`                                                     | Runs test commands with `:!` on Vim, and with `:terminal` on Neovim.                                                                                              |
| **Make**                        | `make` `make_bang`                                          | Runs test commands with `:make` or `:make!`.                                                                                                                      |
| **Neovim**                      | `neovim`                                                    | Runs test commands with `:terminal` in a split window.                                                                                                            |
| **Vim8 Terminal**               | `vimterminal`                                               | Runs test commands with `term_start()` in a split window.                                                                                                         |
| **[Dispatch]**                  | `dispatch` `dispatch_background`                            | Runs test commands with `:Dispatch` or `:Dispatch!`.                                                                                                              |
| **[Vimux]**                     | `vimux`                                                     | Runs test commands in a small tmux pane at the bottom of your terminal.                                                                                           |
| **[Tslime]**                    | `tslime`                                                    | Runs test commands in a tmux pane you specify.                                                                                                                    |
| **[Slimux]**                    | `slimux`                                                    | Runs test commands in a tmux pane you specify.                                                                                                                    |
| **[Neoterm]**                   | `neoterm`                                                   | Runs test commands with `:T`, see neoterm docs for display customization.                                                                                         |
| **[Floaterm]**                  | `floaterm`                                                  | Runs test commands within floating/popup terminal, see [floaterm docs](https://github.com/voldikss/vim-floaterm/blob/master/README.md) for display customization.                                                                                         |
| **[Neomake]**                   | `neomake`                                                   | Runs test commands asynchronously with `:NeomakeProject`.                                                                                                         |
| **[MakeGreen]**                 | `makegreen`                                                 | Runs test commands with `:MakeGreen`.                                                                                                                             |
| **[VimShell]**                  | `vimshell`                                                  | Runs test commands in a shell written in VimScript.                                                                                                               |
| **[Vim&nbsp;Tmux&nbsp;Runner]** | `vtr`                                                       | Runs test commands in a small tmux pane.                                                                                                                          |
| **[Tmuxify]**                   | `tmuxify`                                                   | Runs test commands in a small tmux pane at the bottom of your terminal.                                                                                                                    |
| **[VimProc]**                   | `vimproc`                                                   | Runs test commands asynchronously.                                                                                                                                |
| **[AsyncRun]**                  | `asyncrun` `asyncrun_background` `asyncrun_background_term` | Runs test commands asynchronosuly using new APIs in Vim 8 and NeoVim (`:AsyncRun`, `:AsyncRun -mode=async -silent`, or `:AsyncRun -mode=term -pos=tab -focus=0`). |
| **Terminal.app**                | `terminal`                                                  | Sends test commands to Terminal (useful in MacVim GUI).                                                                                                           |
| **iTerm2.app**                  | `iterm`                                                     | Sends test commands to iTerm2 >= 2.9 (useful in MacVim GUI).                                                                                                      |
| **[Kitty]**                     | `kitty`                                                     | Sends test commands to Kitty terminal.                                                                                                                            |
| **[Shtuff]**                    | `shtuff`                                                    | Sends test commands to remote terminal via [shtuff][Shtuff].                                                                                                      |
| **[Harpoon]**                    | `harpoon`                                                    | Sends test commands to neovim terminal using a terminal managed by [harpoon][Harpoon]. By default commands are sent to terminal number 1, you can choose your terminal by setting `g:test#harpoon_term` with the terminal you want                                                                                                     |

You can also set up strategies per granularity:

```vim
let test#strategy = {
  \ 'nearest': 'neovim',
  \ 'file':    'dispatch',
  \ 'suite':   'basic',
\}
```

or even per command:

```
:TestFile -strategy=neovim
```

Some strategies clear the screen before executing the test command, but you can
disable this:

```vim
let g:test#preserve_screen = 1
```

The Vimux strategy will not clear the screen by default, but you can enable it
by explicitly setting `test#preserve_screen` to `0`.

On Neovim the "basic" and "neovim" strategies will run test commands using
Neovim's terminal, and leave you in insert mode, so that you can just press
"Enter" to close the terminal session and go back to editing. If you want to
scroll through the test command output, you'll have to first switch to normal
mode. The built-in mapping for exiting terminal insert mode is `CTRL-\ CTRL-n`,
which is difficult to press, so I recommend mapping it to `CTRL-o`:

```vim
if has('nvim')
  tmap <C-o> <C-\><C-n>
endif
```

If you prefer, you can instead have the terminal open in normal mode, so it does
not close on key press.

```vim
let g:test#neovim#start_normal = 1 " If using neovim strategy
let g:test#basic#start_normal = 1 " If using basic strategy
```

By default vim-test will echo the test command before running it. You can
disable this behavior with:

```vim
let g:test#echo_command = 0
```

### Kitty strategy setup

Before you can run tests in a kitty terminal window using the kitty strategy,
please make sure:

- you start kitty setting up remote control and specifying a socket for kitty
  to listen to, like this:

  ```
  $ kitty -o allow_remote_control=yes --listen-on unix:/tmp/mykitty
  ```

  or via `kitty.conf`:

  ```
  allow_remote_control yes
  listen_on unix:/tmp/mykitty
  ```

- you export an environment variable `$KITTY_LISTEN_ON` with the same socket, like:

  ```
  $ export KITTY_LISTEN_ON=unix:/tmp/mykitty
  ```

  or if via `kitty.conf` (it appends kitty's PID):

  ```
  $ export KITTY_LISTEN_ON=unix:/tmp/mykitty-$PPID
  ```


### Shtuff strategy setup

This strategy lets you run commands in a remote terminal without needing tools
like `tmux` or special terminals such as Kitty.

Before you can run tests using this strategy, you will need to have a terminal
setup as a receiver, and also you'll need to set `g:shtuff_receiver` in your
vimrc file.

In your terminal of choice:

```
$ shtuff as devrunner
```

And in your vimrc:

```
let g:shtuff_receiver = 'devrunner'
```

### `asyncrun_background` and `asyncrun_background_term` setup

`asyncrun_background` will load test results into the quickfix buffer.

`asyncrun_background_term` will open a terminal in a new tab and run the tests while
remaining in the current window.

These are hardcoded solutions and will not be affected by your global `AsyncRun` settings.
If you want to switch between them then change `test#strategy`.

Note: the base `asyncrun` option will be affected by your global asyncrun settings.

### Quickfix Strategies

If you want your test results to appear in the quickfix window, use one of the
following strategies:

 * Make
 * Neomake
 * MakeGreen
 * Dispatch.vim
 * `asyncrun_background`

Regardless of which you pick, it's recommended you have Dispatch.vim installed as the
strategies will automatically use it to determine the correct compiler, ensuring the
test output is correctly parsed for the quickfix window.

As Dispatch.vim just determines the compiler, you need to make sure the Vim distribution
or a plugin has a corresponding compiler for your test runner, or you may need to write a
compiler plugin.

If the test command prefix doesn't match the compiler's `makeprg` then use the
`g:dispatch_compiler` variable. For example if your test command was `./vendor/bin/phpunit`
but you wanted to use the phpunit2 compiler:

```vim
let g:dispatch_compilers = {}
let g:dispatch_compilers['./vendor/bin/'] = ''
let g:dispatch_compilers['phpunit'] = 'phpunit2'
```

### Custom Strategies

Strategy is a function which takes one argument – the shell command for the
test being run – and it is expected to run that command in some way. Test.vim
comes with many predefined strategies (see above), but if none of them suit
your needs, you can define your own custom strategy:

```vim
function! EchoStrategy(cmd)
  echo 'It works! Command for running tests: ' . a:cmd
endfunction

let g:test#custom_strategies = {'echo': function('EchoStrategy')}
let g:test#strategy = 'echo'
```

## Transformations

You can automatically apply transformations of your test commands by
registering a "transformation" function. The following example demonstrates how
you could set up a transformation for Vagrant:

```vim
function! VagrantTransform(cmd) abort
  let vagrant_project = get(matchlist(s:cat('Vagrantfile'), '\vconfig\.vm.synced_folder ["''].+[''"], ["''](.+)[''"]'), 1)
  return 'vagrant ssh --command '.shellescape('cd '.vagrant_project.'; '.a:cmd)
endfunction

let g:test#custom_transformations = {'vagrant': function('VagrantTransform')}
let g:test#transformation = 'vagrant'
```

## Commands

<img alt="nearest polyfill" src="https://github.com/vim-test/vim-test/blob/master/screenshots/nearest.gif" width=770 height=323>

You can execute test.vim commands directly, and pass them CLI options:

```
:TestNearest --verbose
:TestFile --format documentation
:TestSuite --fail-fast
:TestLast --backtrace
```

If you want some options to stick around, see [Configuring](#configuring).

### Runner commands

Aside from the main commands, you get a corresponding Vim command for each
test runner (which also accept options):

```
:RSpec --tag ~slow
:Mocha --grep 'API'
:ExUnit --trace
:Nose --failed
```

These commands are useful when using multiple testing frameworks in the same
project, or as a wrapper around your executable. To avoid pollution they are
not defined by default, instead you can choose the ones you want:

```vim
let g:test#runner_commands = ['Minitest', 'Mocha']
```

## Configuring

### CLI options

If you want some CLI options to stick around, you can configure them in your
`.vimrc`:

```vim
let test#ruby#minitest#options = '--verbose'
```

You can also choose a more granular approach:

```vim
let test#ruby#rspec#options = {
  \ 'nearest': '--backtrace',
  \ 'file':    '--format documentation',
  \ 'suite':   '--tag ~slow',
\}
```

You can also specify a global approach along with the granular options for the
specified test runner:

```vim
let test#ruby#rspec#options = {
  \ 'all':   '--backtrace',
  \ 'suite': '--tag ~slow',
\}
```

### Vim8 / Neovim terminal position

Both the `neovim` and `Vim8 Terminal` strategy will open a split window on the
bottom by default, but you can configure a different position or orientation.
Whatever you put here is passed to `new` - so, you may also specify size (see
`:help opening-window` or `:help new` for more info):

```vim
" for neovim
let test#neovim#term_position = "topleft"
let test#neovim#term_position = "vert"
let test#neovim#term_position = "vert botright 30"
" or for Vim8
let test#vim#term_position = "belowright"
```

For full list of variants, see `:help opening-window`.

### Executable

You can instruct test.vim to use a custom executable for a test runner.

```vim
let test#ruby#rspec#executable = 'foreman run rspec'
```

### File pattern

Test.vim has file pattern it uses to determine whether a file belongs to
certain testing framework. You can override that pattern by overriding the
`file_pattern` variable:

```vim
let test#ruby#minitest#file_pattern = '_spec\.rb' " the default is '\v(((^|/)test_.+)|_test)(spec)@<!\.rb$'
```

### Filename modifier

By default test.vim generates file paths relative to the working directory. If
you're using a strategy which sends commands to a shell which is `cd`-ed into
another directory, you might want to change the filename modifier to generate
absolute paths:

```vim
let test#filename_modifier = ':.' " test/models/user_test.rb (default)
let test#filename_modifier = ':p' " /User/janko/Code/my_project/test/models/user_test.rb
let test#filename_modifier = ':~' " ~/Code/my_project/test/models/user_test.rb
```

### Working directory

Test.vim relies on you being `cd`-ed into the project root. However, sometimes
you may want to execute tests from a different directory than Vim's current
working directory. You might have a bigger project or monorepo with many subprojects,
or you might be using [`autochdir`]. In any case, you can tell test.vim to use a
different working directory for running tests:

```vim
let test#project_root = "/path/to/your/project"
```

### Language-specific

#### Python

Since there are multiple Python test runners for the same type of tests,
test.vim has no way of detecting which one did you intend to use. By default
the first available will be chosen, but you can force a specific one:

``` vim
let test#python#runner = 'pytest'
" Runners available are 'pytest', 'nose', 'nose2', 'djangotest', 'djangonose', 'mamba', and Python's built-in unittest as 'pyunit'
```

The pytest runner optionally supports [pipenv](https://github.com/pypa/pipenv).
If you have a `Pipfile`, it will use `pipenv run pytest` instead of just
`python -m pytest`. It also supports [poetry](https://github.com/sdispater/poetry)
and will use `poetry run pytest` if it detects a `poetry.lock`. The pyunit
runner supports [pipenv](https://github.com/pypa/pipenv) as well and will
use `pipenv run python -m unittest` if there is a `Pipfile`.

#### Java

For the same reason as Python, runner detection works the same for Java. To
force a specific runner:

``` vim
let test#java#runner = 'gradletest'
```

There is a specific strategy for Java with maven which invokes the mvn verify for a file instead of mvn test tailored for integration tests. In this way you can leverage the pre-integration goals, like firing up a database and so on. This strategy is called 'integration' and you can setup a command for it (preferably within the Java filetype plugin):

``` vim
command! -nargs=* -bar IntegrationTest call test#run('integration', split(<q-args>))
```

With this set up you can run your integration tests with the :IntegrationTest plugin for that single file and module. As there might be some dependencies between the maven modules you might need to pass in other parameters for the tests just like any other commands in vim-test. Here is a mapping with other optional parameters:


``` vim
nnoremap <silent><leader>itf :IntegrationTest -Dtest=foo -DfailIfNoTests=false -am -Dpmd.skip=true -Dcheckstyle.skip=true<CR>
```

The above command makes sure that no surefire tests will be run (by passing in a dummy test and makes sure that the plugin won't fail), it also makes the dependent modules, skips PMD and checkstyle checks as well.

#### Scala

For the same reason as Python, runner detection works the same for Scala. To
force a specific runner:

``` vim
let test#scala#runner = 'blooptest'
```

You may have subprojects inside your main sbt projects. Bloop project detection
uses your main project to run tests. If you need to run test inside your subproject,
you can specify custom projects with:

```vim
let g:test#scala#blooptest#project_name = 'custom-project'
```

With this configuration, the test runner will run test for `custom-project`:

```sh
$ bloop test custom-project
```

#### Go

For the same reason as Python, runner detection works the same for Go. To
force a specific runner:

``` vim
let test#go#runner = 'ginkgo'
" Runners available are 'gotest', 'ginkgo', 'richgo', 'delve'
```

You can also configure the `delve` runner with a different key mapping
alongside another:

```vim
nmap <silent> t<C-n> :TestNearest<CR>
function! DebugNearest()
  let g:test#go#runner = 'delve'
  TestNearest
  unlet g:test#go#runner
endfunction
nmap <silent> t<C-d> :call DebugNearest()<CR>
```

If `delve` is selected and [vim-delve](https://github.com/sebdah/vim-delve) is
in use, breakpoints and tracepoints that have been marked with vim-delve will
be included.

#### Ruby

Unless binstubs are detected (e.g. `bin/rspec`), test commands will
automatically be prepended with `bundle exec` if a Gemfile is detected, but you
can turn it off:

```vim
let test#ruby#bundle_exec = 0
```

If binstubs are detected, but you don't want to use them, you can turn them off:

```vim
let test#ruby#use_binstubs = 0
```

If your binstubs are not instrumented with spring, you can turn on using the `spring` bin (`bin/spring`) directly using:

```vim
let test#ruby#use_spring_binstub = 1
```

#### JavaScript

Test runner detection for JavaScript works by checking which runner is listed in the package.json dependencies. If you have globally installed the runner make sure it's also listed in the dependencies. When you have multiple runners listed in the package.json dependencies you can specify a runner like so:

```vim
let g:test#javascript#runner = 'jest'
```

#### Haskell

The `stackTest` runner currently supports running tests in Stack projects with the [HSpec](http://hackage.haskell.org/package/hspec) framework.

#### PHP

The PHPUnit runner has support for the alternate runner [ParaTest](https://github.com/paratestphp/paratest) and will automatically use it if present in `./vendor/bin`. If you prefer to use PHPUnit then override the executable:

```vim
let test#php#phpunit#executable = 'phpunit'
```

Similarly if you'd prefer to use an alternate runner such as the [Laravel artisan runner](https://laravel.com/docs/7.x/testing) then override the executable:

```vim
let test#php#phpunit#executable = 'php artisan test'
```

#### C++
Pattern for Test File: We assume all your test files are prefixed with "test_" or "Test". If not, override the following:
```
"Default
let g:test#cpp#catch2#file_pattern = '\v[tT]est.*(\.cpp)$'
```
File and Individual Test Case: We assume you are using make to compile your executables, whose names are exactly the same as the test file w/o the extension. If you would like to use change the make command, override the following:
```
let g:test#cpp#catch2#make_command = "make"
```
Creating Test Executables: We assume that a Makefile is located in a "build" directory directly below the project root. If not, override the following:
```
" If Makefile is at top of the project root, do this instead
let g:test#cpp#catch2#relToProject_build_dir = "."
```
We assume that your compiled executables are stored in `build` directory. If not, you can override this with:
```vim
let g:test#cpp#catch2#bin_dir = "../path/to/your/binaries/dir" 
```
Suite: We assume that you are using Cmake as your build system, and are registering each test file to it. If not, override the following command.
```vim
let g:test#cpp#catch2#suite_command = "ctest --ouput-on-failure" 
```

## Autocommands

In addition to running tests manually, you can also configure autocommands
which run tests automatically when files are saved.

The following setup will automatically run tests when a test file or its
alternate application file is saved:

```vim
augroup test
  autocmd!
  autocmd BufWrite * if test#exists() |
    \   TestFile |
    \ endif
augroup END
```

## Projectionist integration

If [projectionist.vim] is present, you can run a test command from an
application file, and test.vim will automatically try to run the
command on the "alternate" test file.

You can disable this integration by doing
```vim
let g:test#no_alternate = 1
```

### Custom alternate file

If you are using a different library for jumping between implementation and test file
you can define a custom function that returns the test filename.

```vim
function! CustomAlternateFile(cmd)
  return "test_file_spec.rb"
endfunction

let g:test#custom_alternate_file = function('echo')
```

## Extending

If you wish to extend this plugin with your own test runners, first of all,
if the runner is well-known, I would encourage to help me merge it into
test.vim.

That being said, if you want to do this for yourself, you need to do 2 things.
First, add your runner to the list in your `.vimrc`:

```vim
" First letter of runner's name must be uppercase
let test#custom_runners = {'MyLanguage': ['MyRunner']}
```

Second, create `~/.vim/autoload/test/mylanguage/myrunner.vim`, and define the following
methods:

```vim
" Returns true if the given file belongs to your test runner
function! test#mylanguage#myrunner#test_file(file)

" Returns test runner's arguments which will run the current file and/or line
function! test#mylanguage#myrunner#build_position(type, position)

" Returns processed args (if you need to do any processing)
function! test#mylanguage#myrunner#build_args(args)

" Returns the executable of your test runner
function! test#mylanguage#myrunner#executable()
```

See [`autoload/test`](/autoload/test) for examples.

## Choosing which runners to load

All runners are loaded by default. To select which runners to load, set this
option:

```vim
let test#enabled_runners = ["mylanguage#myrunner", "ruby#rspec"]
```

All other runners will not be loaded.

Note that for your own custom runners, you still need to set `test#custom_runners`.

## Running tests

Tests are run using a Ruby test runner, so you'll have to have Ruby installed.
Then run

```sh
$ gem install vim-flavor
```

Now you can run tests with

```sh
$ vim-flavor test spec/
```

Or if you're inside of Vim, you can simply run `:VSpec` provided by test.vim.

## Credits

This plugin was strongly influenced by Gary Bernhardt's Destroy All Software.
I also want to thank [rspec.vim], from which I borrowed GUI support for OS X,
and Windows support. And also thanks to [vroom.vim].

## License

Copyright © Janko Marohnić. Distributed under the same terms as Vim itself. See
`:help license`.

[minitest]: https://github.com/vim-test/vim-test/wiki/Minitest
[Neoterm]: https://github.com/kassio/neoterm
[Floaterm]: https://github.com/voldikss/vim-floaterm
[Neomake]: https://github.com/neomake/neomake
[Dispatch]: https://github.com/tpope/vim-dispatch
[Vimux]: https://github.com/benmills/vimux
[Tslime]: https://github.com/jgdavey/tslime.vim
[Slimux]: https://github.com/esamattis/slimux
[Vim&nbsp;Tmux&nbsp;Runner]: https://github.com/christoomey/vim-tmux-runner
[Tmuxify]: https://github.com/jebaum/vim-tmuxify
[VimShell]: https://github.com/Shougo/vimshell.vim
[VimProc]: https://github.com/Shougo/vimproc.vim
[`autochdir`]: http://vimdoc.sourceforge.net/htmldoc/options.html#'autochdir'
[rspec.vim]: https://github.com/thoughtbot/vim-rspec
[vroom.vim]: https://github.com/skalnik/vim-vroom
[AsyncRun]: https://github.com/skywind3000/asyncrun.vim
[MakeGreen]: https://github.com/reinh/vim-makegreen
[M]: http://github.com/qrush/m
[projectionist.vim]: https://github.com/tpope/vim-projectionist
[Kitty]: https://github.com/kovidgoyal/kitty
[Shtuff]: https://github.com/jfly/shtuff
[Harpoon]: https://github.com/ThePrimeagen/harpoon
