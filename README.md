# test.vim

This plugin provides Vim commands that wrap test runners allowing you to easily
run tests on different granularities:

* Run nearest test (to the cursor)
* Run (current) test file
* Run test suite
* Run last test

Currently the following testing frameworks are supported:

| Language       | Frameworks                    |
| :------------: | ----------------------------- |
| **Ruby**       | RSpec<br>Minitest<br>Cucumber |
| **JavaScript** | Mocha<br>Jasmine              |
| **Python**     | Nose<br>PyTest                |
| **Elixir**     | ExUnit                        |
| **Go**         | Go                            |
| **Clojure**    | Fireplace.vim                 |
| **Shell**      | Bats                          |
| **VimScript**  | VSpec                         |
| **Lua**        | Busted                        |

## Introduction

Since Gary Bernhardt invented testing from Vim, there have been multiple
plugins implementing this functionality. However, I found none of the current
solutions to be good enough. I wanted a testing plugin which:

* doesn't require any dependencies in order to work
* requires zero configuration (it "does the right thing")
* automatically chooses the correct test runner
* allows more customized configuration of CLI options
* supports testing frameworks for languages other than Ruby
* is easily extendable with new test runners

I believe `vim-test` achieved all of the above, and more.

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

## Commands

The testing commands act a bit "smarter" than what you might be used to, so
be sure to keep reading.

#### `:TestNearest`

When in a test file, runs the test nearest to the cursor (some frameworks may
not support this). If not in a test file, it remembers where your cursor was
*before* you switched to production code, and runs test nearest to that
position.

#### `:TestFile`

When in a test file, runs all tests in that file. If not in a test file, it
remembers the last visited test file, and runs tests for it.

#### `:TestSuite`

When in a test file, runs the test suite this file belongs to. If not in test
file, it runs the test suite last visited test file belongs to.

### Test runner commands

Aside from the above commands, each supported test runner also gets a
corresponding Vim command:

```
:RSpec
:Cucumber
:Mocha
:Jasmine
...
```

These wrappers run the underlying test runners with proper executables and
options. For example:

* `:RSpec` will use the first available from the following: `bin/rspec`,
  `bundle exec rspec` or `rspec`.
* `:Mocha` will automatically include `--compilers coffee:coffee-script` if it
  detects CoffeeScript files in your test directory.

I found these commands to be really useful when you have multiple test suites.

## Configuring

### Strategies

`vim-test` can run your tests in various ways.

#### Basic (default)

```vim
let g:test#strategy = 'basic'    " :!<test command>
```

#### Make

```vim
let g:test#strategy = 'make'     " :make
```

#### Dispatch.vim

```vim
let g:test#strategy = 'dispatch' " :Make
```

#### Vimux

```vim
let g:test#strategy = 'vimux'    " VimuxRunCommand(<test commmand>)
```

#### Tslime.vim

```vim
let g:test#strategy = 'tslime'   " Send_to_Tmux(<test command>)
```

#### GUI

If you're in MacVim GUI, `vim-test` also supports sending test commands to the
terminal.

```vim
let g:test#strategy = 'terminal'
" or
let g:test#strategy = 'iterm'
```

### Options

All of the commands above accept optional arguments which are forwarded to the
underlying test runner.

```
:TestFile --seed 1425
:Minitest --verbose
```

If you want some options to stick around, you can assign them globally to a
variable:

```vim
let g:test#ruby#minitest#options = '--verbose'
```

Or you can choose a more granular approach:

```vim
let g:test#ruby#rspec#options = {
  \ 'nearest': '--format documentation',
  \ 'file':    '--format documentation',
  \ 'suite':   '--tag ~slow',
\}
```

### Executable

If you're using a custom executable for test runner which `vim-test` already
has, you can tell `vim-test` to use your executable:

```vim
let g:test#ruby#rspec#executable = 'script/my_rspec'
```

### Language-specific

#### Python

Since there are multiple Python test runners for the same type of tests,
`vim-test` has no way of detecting which one did you intend to use. By default
the first available will be chosen, but you can force a specific one:

``` vim
let g:test#python#runner = 'pytest'
" or
let g:test#python#runner = 'nose'
```

## Extending

If you wish to extend this plugin with your own test runners, first of all,
if the runner is well-known, I would encourage to help me merge it into
`vim-test`.

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

If you're using dispatch.vim, and the compiler for your runner isn't called
the same (in this case "myrunner"), you can also define

```vim
let g:test#mylanguage#myrunner#compiler = "<compiler>"
```

See [`autoload/test/`](/autoload/test) for examples.

## Credits

This plugin was strongly influenced by Gary Bernhardt's Destroy All Software.
I also want to thank [vim-rspec](https://github.com/thoughtbot/vim-rspec), from
which I borrowed GUI support for OS X, and Windows support.

## License

Copyright © Janko Marohnić. Distributed under the same terms as Vim itself. See
`:help license`.
