# Contributing to vim-test

Thank you for your interest in contributing to vim-test! This document provides guidelines and information for contributors.

## Adding a New Test Runner

When adding support for a new test runner, follow these steps:

### 1. Create the Runner Implementation

Create a new file at `autoload/test/[language]/[runner].vim` with the following required functions:

```vim
" Returns true if the given file belongs to your test runner
function! test#[language]#[runner]#test_file(file)

" Returns test runner's arguments which will run the current file and/or line
function! test#[language]#[runner]#build_position(type, position)

" Returns processed args (if you need to do any processing)
function! test#[language]#[runner]#build_args(args)

" Returns the executable of your test runner
function! test#[language]#[runner]#executable()
```

### 2. Add Test Fixtures

Create appropriate test fixtures in `spec/fixtures/[runner]/` that demonstrate the test runner's file patterns and structure.

### 3. Write Specs

Create a spec file at `spec/[runner]_spec.vim` to test your runner implementation.

### 4. Update Documentation

- Add your test runner to the `README.md` table with language, runner name, and identifier
- Update `doc/test.txt` with relevant documentation

By contributing to vim-test, you agree that your contributions will be licensed under the [MIT License](https://opensource.org/license/MIT).
