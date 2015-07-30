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
