# test.vim

This plugin provides Vim commands that wrap test runners allowing you to easily
run tests on different granularities:

* Run nearest test (to the cursor)
* Run (current) test file
* Run test suite
* Run last test

![usage overview](/screenshots/granularity.gif)

Currently the following testing frameworks are supported:

| Language       | Frameworks                            |
| :------------: | ------------------------------------- |
| **Ruby**       | RSpec, [Minitest][minitest], Cucumber |
| **JavaScript** | Mocha, Jasmine                        |
| **Python**     | Nose, PyTest                          |
| **Elixir**     | ExUnit                                |
| **Go**         | Go                                    |
| **Clojure**    | Fireplace.vim                         |
| **Shell**      | Bats                                  |
| **VimScript**  | VSpec, Vader.vim                      |
| **Lua**        | Busted                                |

## Introduction

Since Gary Bernhardt invented testing from Vim, there have been multiple
plugins implementing this functionality. However, I found none of the current
solutions to be good enough. Thus test.vim was born, featuring:

* zero dependencies
* zero configuration required (it Does the Right Thing™)
* abstraction for testing frameworks (and easily extendable)
* automatic detection of correct test runner
* **polyfill** for nearest tests (by constructing regexes)
* fully customized CLI options configuration

## Setup

```vim
Plug[in] 'janko-m/vim-test'
```

Add your preferred mappings to your `.vimrc` file:

```vim
nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>T :TestFile<CR>
nmap <silent> <leader>a :TestSuite<CR>
nmap <silent> <leader>l :TestLast<CR>
```

## Strategies

You can instruct test.vim to run your tests with different strategies (with
synchronous or **asynchronous** execution).

### Basic (default)

Runs test commands with `:!`, which switches your Vim to the Terminal.

```vim
let g:test#strategy = 'basic'
```

### Dispatch.vim

Runs test commands with `:Dispatch`. Requires the
[Dispatch.vim](https://github.com/tpope/vim-dispatch) plugin.

```vim
let g:test#strategy = 'dispatch'
```

### Vimux

Runs test commands in a small Tmux pane at the bottom of your Terminal.
Requires the [Vimux](https://github.com/benmills/vimux) plugin (and Tmux).

```vim
let g:test#strategy = 'vimux'
```

### Tslime.vim

Runs test commands in a Tmux pane you specify. Requires the
[Tslime.vim](https://github.com/kikijump/tslime.vim) plugin (and Tmux).

```vim
let g:test#strategy = 'tslime'
```

### Terminal.app / iTerm.app

If you're in MacVim GUI, you can use this strategy to send the test commands
to your Terminal.app/iTerm.app (since executing shell commands inside Vim GUIs
isn't that nice).

```vim
let g:test#strategy = 'terminal'
" or
let g:test#strategy = 'iterm'
```

## Commands

![nearest polyfill](/screenshots/nearest.gif)

Test.vim gives you `:TestNearest`, `:TestFile`, `:TestSuite` and `:TestLast`
commands, which you can run directly (and pass them options).

```
:TestNearest --verbose
:TestFile --format documentation
:TestSuite --fail-fast
```

If you want some options to stick around, see [Configuring](#configuring).

### Runner commands

Aside from the above commands, you get a corresponding Vim command for each
test runner (which also accept options):

```
:RSpec --tag ~slow
:Mocha --grep 'API'
:ExUnit --trace
:Nose --failed
```

I found these commands to be really useful when having multiple test suites.

## Configuring

### CLI options

If you want some CLI options to stick around, you can configure them in your
`.vimrc`:

```vim
let g:test#ruby#minitest#options = '--verbose'
```

You can also choose a more granular approach:

```vim
let g:test#ruby#rspec#options = {
  \ 'nearest': '--backtrace',
  \ 'file':    '--format documentation',
  \ 'suite':   '--tag ~slow',
\}
```
### Executable

You can instruct test.vim to use a custom executable for a test runner.

```vim
let g:test#ruby#rspec#executable = 'script/my_rspec'
```

### Language-specific

#### Python

Since there are multiple Python test runners for the same type of tests,
test.vim has no way of detecting which one did you intend to use. By default
the first available will be chosen, but you can force a specific one:

``` vim
let g:test#python#runner = 'pytest'
" or
let g:test#python#runner = 'nose'
```

## Extending

If you wish to extend this plugin with your own test runners, first of all,
if the runner is well-known, I would encourage to help me merge it into
test.vim.

That being said, if you want to do this for yourself, you need to do 2 things.
First, add your runner to the list in your `.vimrc`:

```vim
" First letter of runner's name must be uppercase
let g:test#runners = {'MyLanguage': ['MyRunner']}
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

## Credits

This plugin was strongly influenced by Gary Bernhardt's Destroy All Software.
I also want to thank [rspec.vim](https://github.com/thoughtbot/vim-rspec), from
which I borrowed GUI support for OS X, and Windows support. And also thanks to
[vroom.vim](https://github.com/skalnik/vim-vroom).

## License

Copyright © Janko Marohnić. Distributed under the same terms as Vim itself. See
`:help license`.

[minitest]: https://github.com/janko-m/vim-test/wiki/Minitest
