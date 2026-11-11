# Contributing to vim-test

Thank you for your interest in contributing to vim-test! This document provides guidelines and information for contributors.

## Commit Messages

 - Use [conventional commits](https://www.conventionalcommits.org/en/v1.0.0/).
 - The commit description should capture why the change was made

## Code Conventions

 - Only use Vimscript
 - Neovim specific functions can be used if there is fallback functionality for Vim

## Design Principles

 - Zero configuration philosophy. Runners should be detected automatically with no configuration; avoid adding new configuration options when adding functionality.

## Project Layout

- `plugin/test.vim` — plugin entry point, defines commands and mappings
- `autoload/test.vim` — core plugin logic
- `autoload/test/[language]/[runner].vim` — test runner implementations
- `autoload/test/[language].vim` — logic shared between runners for a language
- `spec/` — test specs (vim-flavor)
- `spec/fixtures/[runner]/` — sample projects used by the specs
- `doc/test.txt` — Vim user documentation

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

Any logic that is common to runners for that language should be added to `autoload/test/[language].vim`.
Add any root markers files for the language, as follows:

```vim
" Returns a list of language specific root markers eg ['package.json']
function! test#[language]#list_root_markers()
```

### 2. Add Test Fixtures

Create appropriate test fixtures in `spec/fixtures/[runner]/` that demonstrate the test runner's file patterns and structure.

### 3. Write Specs

Create a spec file at `spec/[runner]_spec.vim` to test your runner implementation.

### 4. Update Documentation

- Add your test runner to the `README.md` table with language, runner name, and identifier
- Update `doc/test.txt` with relevant documentation

## Updating an Existing Test Runner

When implementing or updating a test runner, keep the same checklist as for new runners:

- Update the spec in `spec/[runner]_spec.vim` and add or adjust fixtures in `spec/fixtures/[runner]/`
- Update `doc/test.txt` if the behaviour or options change

## Testing Instructions

- Install dependencies: `gem install vim-flavor`
- Install project dependencies: `vim-flavor install`
- Run all tests: `vim-flavor test spec/`
- Run specific test file: `vim-flavor test spec/[filename]_spec.vim`
- Test fixtures in `spec/fixtures/` provide examples for each supported test runner

By contributing to vim-test, you agree that your contributions will be licensed under the [MIT License](https://opensource.org/license/MIT).
