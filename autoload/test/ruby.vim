let test#ruby#patterns = {
  \ 'test': [
    \ '\v^\s*def (test_\w+)',
    \ '\v^\s*test%(\(| )%("|'')(.*)%("|'')',
    \ '\v^\s*it%(\(| )%("|'')(.*)%("|'')',
    \ '\v^\s*it\s\{(.*)\s\}',
  \],
  \ 'namespace': [
    \ '\v^\s*%(class|module) (\S+)',
    \ '\v^\s*%(describe|context)%(\(| )%("|'')(.*)%("|'')',
    \ '\v^\s*%(describe|context)%(\(| )(\S+)',
  \],
\}

function! test#ruby#use_zeus() abort
  return !empty(glob('.zeus.sock'))
endfunction

function! test#ruby#use_bundle_exec() abort
  return filereadable('Gemfile') && get(g:, 'test#ruby#bundle_exec', 1)
endfunction

function! test#ruby#use_spring() abort
  return filereadable('./bin/spring') && get(g:, 'test#ruby#use_spring_binstub', 0)
endfunction

function! test#ruby#determine_executable(cmd) abort
  if test#ruby#use_zeus()
    return 'zeus ' . a:cmd
  elseif test#ruby#use_spring()
    return './bin/spring ' . a:cmd
  elseif filereadable('./bin/' . a:cmd) && get(g:, 'test#ruby#use_binstubs', 1)
    return './bin/' . a:cmd
  elseif test#ruby#use_bundle_exec()
    return 'bundle exec ' . a:cmd
  else
    return a:cmd
  endif
endfunction
