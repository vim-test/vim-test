if !exists('g:test#javascript#intern#file_pattern')
  let g:test#javascript#intern#file_pattern = '\vtests?/.*\.js$'
endif

if !exists('g:test#javascript#intern#test_runner')
  let g:test#javascript#intern#test_runner = 'intern-client'
endif

if !exists('g:test#javascript#intern#config_module')
  let g:test#javascript#intern#config_module = 'tests/intern'
endif

function! test#javascript#intern#test_file(file) abort
  return a:file =~# g:test#javascript#intern#file_pattern
    \ && filereadable(g:test#javascript#intern#config_module . '.js')
    \ && test#javascript#has_package('intern')
endfunction

function! test#javascript#intern#build_position(type, position) abort
  let filename = fnamemodify(a:position['file'], ':r')
  if  filename =~# '\vtests?/functional/.*$'
    let suite = 'functionalSuites=' . filename
  else
    let suite = 'suites=' . filename
  endif

  if a:type ==# 'nearest'
    let name = s:nearest_test(a:position)
    if !empty(name)
      return [suite, 'grep=' . shellescape(name, 1)]
    else
      return [suite]
    endif
  elseif a:type ==# 'file'
    return [suite]
  else
    return []
  endif
endfunction

function! test#javascript#intern#build_args(args) abort
  let config = 'config=' . g:test#javascript#intern#config_module
  return [config] + a:args
endfunction

function! test#javascript#intern#executable() abort
  if filereadable('node_modules/.bin/' . g:test#javascript#intern#test_runner)
    return 'node_modules/.bin/'. g:test#javascript#intern#test_runner
  else
    return g:test#javascript#intern#test_runner
  endif
endfunction

function! s:nearest_test(position) abort
  let patterns = {
    \ 'test': [
      \ '\v^\s*%(%(bdd\.)?it|%(tdd\.|QUnit\.)?test)\s*[( ]\s*%("|'')(.*)%("|'')',
      \ '\v^\s*%("|'')(.*)%("|'')\s*:\s*function\s*[(]'
    \] + g:test#javascript#patterns['test'],
    \ 'namespace': [
      \'\v^\s*%(%(bdd\.)?describe|%(tdd\.)?suite|%(QUnit\.)?module)\s*[( ]\s*%("|'')(.*)%("|'')',
      \ '\v^\s*registerSuite\s*[(]\s*[{]\s*name\s*:\s*%("|'')(.*)%("|'')',
      \ '\v^\s*%("|'')(.*)%("|'')\s*:\s*[{]'
    \] + g:test#javascript#patterns['namespace'],
  \}

  let name = test#base#nearest_test(a:position, l:patterns)

  return (len(name['namespace']) ? '^' : '') . 
       \ test#base#escape_regex(join(name['namespace'] + name['test'], ' - ')) .
       \ (len(name['test']) ? '$' : ' - ')
endfunction
