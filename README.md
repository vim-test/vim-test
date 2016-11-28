# test.vim

A Vim wrapper for running tests on different granularities.

![usage overview](/screenshots/granularity.gif)

Currently the following testing frameworks are supported:

| Language       | Frameworks                                      | Identifiers                                  |
| :------------: | -------------------------------------           | -------------------------------------------- |
| **Ruby**       | RSpec, [Minitest][minitest]/Rails/[M], Cucumber | `rspec`, `minitest`/`rails`/`m`, `cucumber`  |
| **JavaScript** | Intern, TAP, Karma, Mocha, Jasmine              | `intern`, `tap`, `karma`, `mocha`, `jasmine` |
| **Python**     | Nose, PyTest, Django                            | `nose`, `pytest`, `djangotest`, `djangonose` |
| **Elixir**     | ExUnit, ESpec                                   | `exunit`, `espec`                            |
| **Go**         | Go                                              | `gotest`                                     |
| **Rust**       | Cargo                                           | `cargotest`                                  |
| **Clojure**    | Fireplace.vim                                   | `fireplacetest`                              |
| **Shell**      | Bats                                            | `bats`                                       |
| **VimScript**  | VSpec, Vader.vim                                | `vspec`, `vader`                             |
| **Lua**        | Busted                                          | `busted`                                     |
| **PHP**        | PHPUnit, Behat, PHPSpec, Codeception            | `phpunit`, `behat`, `phpspec`, `codeception` |
| **Perl**       | Prove                                           | `prove`                                      |
| **Java**       | Maven                                           | `maventest`                                  |

## Features

* Zero dependencies
* Zero configuration required (it Does the Right Thing™, see [**Philosophy**](https://github.com/janko-m/vim-test/wiki))
* Wide range of test runners which are automagically detected
* **Polyfills** for nearest tests (by [constructing regexes](#commands))
* Wide range of execution environments ("[strategies](#strategies)")
* Fully customized CLI options configuration
* Extendable with new runners and strategies

Test.vim consists of a core which provides an abstraction over running any kind
of tests from the command-line. Concrete test runners are then simply plugged
in, so they all work in the same unified way.

## Setup

Using [vim-plug](https://github.com/junegunn/vim-plug), add 
```vim
Plug 'janko-m/vim-test'
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

| Command        | Description                                                                                                                                                                                                                                                                            |
| :-------       | :-----------                                                                                                                                                                                                                                                                           |
| `:TestNearest` | In a test file runs the test nearest to the cursor, otherwise runs the last nearest test. In test frameworks that don't support line numbers it will **polyfill** this functionality with [regexes](#commands).                                                                        |
| `:TestFile`    | In a test file runs all tests in the current file, otherwise runs the last file tests.                                                                                                                                                                                                 |
| `:TestSuite`   | Runs the whole test suite (if the current file is a test file, runs that framework's test suite, otherwise determines the test framework from the last run test).                                                                                                                      |
| `:TestLast`    | Runs the last test.                                                                                                                                                                                                                                                                    |
| `:TestVisit`   | Visits the test file from which you last run your tests (useful when you're trying to make a test pass, and you dive deep into application code and close your test buffer to make more space, and once you've made it pass you want to go back to the test file to write more tests). |

## Strategies

Test.vim can run tests using different execution environments called
"strategies". To use a specific strategy, assign it to a variable:

```vim
" make test commands execute using dispatch.vim
let test#strategy = "dispatch"
```

| Strategy                        | Identifier | Description                                                                      |
| :-----:                         | :-----:    | :----------                                                                      |
| **Basic**&nbsp;(default)        | `basic`    | Runs test commands with `:!`, which switches your Vim to the terminal.           |
| **Make**                        | `make`     | Runs test commands with `:make`.                                                 |
| **Neovim**                      | `neovim`   | Runs test commands with `:terminal`, which spawns a terminal inside your Neovim. |
| **[Dispatch]**                  | `dispatch` | Runs test commands with `:Dispatch`.                                             |
| **[Vimux]**                     | `vimux`    | Runs test commands in a small tmux pane at the bottom of your terminal.          |
| **[Tslime]**                    | `tslime`   | Runs test commands in a tmux pane you specify.                                   |
| **[Neoterm]**                   | `neoterm`  | Runs test commands with `:T`, see neoterm docs for display customization.        |
| **[VimShell]**                  | `vimshell` | Runs test commands in a shell written in VimScript.                              |
| **[Vim&nbsp;Tmux&nbsp;Runner]** | `vtr`      | Runs test commands in a small tmux pane.                                         |
| **[VimProc]**                   | `vimproc`  | Runs test commands asynchronously.                                               |
| **Terminal.app**                | `terminal` | Sends test commands to Terminal (useful in MacVim GUI).                          |
| **iTerm2.app**                  | `iterm`    | Sends test commands to iTerm2 >= 2.9 (useful in MacVim GUI).                     |

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

![nearest polyfill](/screenshots/nearest.gif)

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
let test#ruby#minitest#file_pattern = '_spec\.rb' " the default is '_test\.rb'
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
working directory. You might have a bigger project with many subprojects, or
you might be using [`autochdir`]. In any case, you can tell test.vim to use a
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
" Runners available are 'pytest', 'nose', 'djangotest' and 'djangonose'
```

#### Ruby

Unless binstubs are detected (e.g. `bin/rspec`), test commands will
automatically be prepended with `bundle exec` if a Gemfile is detected, but you
can turn it off:

```vim
let test#ruby#bundle_exec = 0
```

## Extending

If you wish to extend this plugin with your own test runners, first of all,
if the runner is well-known, I would encourage to help me merge it into
test.vim.

That being said, if you want to do this for yourself, you need to do 2 things.
First, add your runner to the list in your `.vimrc`:

```vim
" First letter of runner's name must be uppercase
let test#runners = {'MyLanguage': ['MyRunner']}
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

[minitest]: https://github.com/janko-m/vim-test/wiki/Minitest
[Neoterm]: https://github.com/kassio/neoterm
[Dispatch]: https://github.com/tpope/vim-dispatch
[Vimux]: https://github.com/benmills/vimux
[Tslime]: https://github.com/jgdavey/tslime.vim
[Vim&nbsp;Tmux&nbsp;Runner]: https://github.com/christoomey/vim-tmux-runner
[VimShell]: https://github.com/Shougo/vimshell.vim
[VimProc]: https://github.com/Shougo/vimproc.vim
[`autochdir`]: http://vimdoc.sourceforge.net/htmldoc/options.html#'autochdir'
[rspec.vim]: https://github.com/thoughtbot/vim-rspec
[vroom.vim]: https://github.com/skalnik/vim-vroom
[M]: http://github.com/qrush/m
