if !exists('g:test#php#behat#file_pattern')
  let g:test#php#behat#file_pattern = '\v\.feature$'
endif

if !exists('g:test#php#behat#bootstrap_directory')
  let g:test#php#behat#bootstrap_directory = 'features/bootstrap/**/*.php'
endif

function! test#php#behat#test_file(file) abort
  if a:file =~# g:test#php#behat#file_pattern
    return !empty(glob(g:test#php#behat#bootstrap_directory))
  endif
endfunction

function! test#php#behat#build_position(type, position) abort
  if a:type ==# 'nearest'
    let name = s:nearest_test(a:position)
    if !empty(name) | let name = '--name '.shellescape(name, 1) | endif
    return [a:position['file'], name]
  elseif a:type ==# 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#php#behat#build_args(args, color) abort
  let args = a:args

  if !a:color
    let args = ['--no-ansi'] + args
  endif

  return args
endfunction

function! test#php#behat#executable() abort
  if filereadable('./vendor/bin/behat')
    return './vendor/bin/behat'
  elseif filereadable('./bin/behat')
    return './bin/behat'
  else
    return 'behat'
  endif
endfunction

function! s:nearest_test(position) abort
  let patterns = {'test': ['\vScenario%(\s*Outline)?: (.*)'], 'namespace': []}
  let name = test#base#nearest_test(a:position, patterns)
  return join(name['test'])
endfunction
