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
| **Python**     | Nose                          |
| **Elixir**     | ExUnit                        |
| **Go**         | GoTest                        |
| **Shell**      | Bats                          |
| **VimScript**  | VSpec                         |

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

When in a test file, runs the test nearest to the cursor (even for Minitest and
Mocha). If not in a test file, it remembers where your cursor was *before* you
switched to production code, and runs test nearest to that position.

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

`vim-test` supports multiple ways ("strategies") of running your tests, just
pick the one that suits you the most.

#### Dispatch.vim

```vim
let g:test#strategy = 'dispatch'
```

#### Vimux

```vim
let g:test#strategy = 'vimux'
```

#### Tslime.vim

```vim
let g:test#strategy = 'tslime'
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
let g:test#minitest#options = '--verbose'
```

Or you can choose a more granular approach:

```vim
let g:test#rspec#options = {
  \ 'nearest': '--format documentation',
  \ 'file':    '--format documentation',
  \ 'suite':   '--tag ~slow',
\}
```

### Executable

If you're using a custom executable for test runner which `vim-test` already
has, you can tell `vim-test` to use your executable:

```vim
let g:test#rspec#executable = 'script/my_rspec'
```

If you have a custom test runner that you wish to integrate with `vim-test`,
see the next section.

## Extending

If you wish to extend this plugin with your own test runners, first of all,
if the runner is well-known, I would encourage to help me merge it into
`vim-test`.

That being said, if you want to do this for yourself, you need to do 2 things.
First, add your runner to the list in your `.vimrc`:

```vim
let g:test#runners = ['MyRunner'] " First letter *must* be uppercase
```

Second, create `~/.vim/autoload/test/myrunner.vim`, and define the following
methods:

```vim
" Returns true if the given file belongs to your test runner
function! test#myrunner#test_file(file)

" Returns test runner's arguments which will run the current file and/or line
function! test#myrunner#build_position(type, position)

" Returns processed args (if you need to do any processing)
function! test#myrunner#build_args(args)

" Returns the executable of your test runner
function! test#myrunner#executable()
```

If you're using dispatch.vim, and the compiler for your runner isn't called
the same (in this case "myrunner"), you can also define

```vim
let g:test#myrunner#compiler = "<compiler>"
```

See [`autoload/test/`](/autoload/test) for examples.

## Credits

This plugin was strongly influenced by Gary Bernhardt's Destroy All Software.
I also want to thank [vim-rspec](https://github.com/thoughtbot/vim-rspec), from
which I borrowed GUI support for OS X, and Windows support.

## License

Copyright © Janko Marohnić. Distributed under the same terms as Vim itself. See
`:help license`.
