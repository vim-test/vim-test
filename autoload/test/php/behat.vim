function! test#php#behat#test_file(file) abort
  if a:file =~# '\.feature$'
    return !empty(glob('features/bootstrap/**/*.php'))
  endif
endfunction

function! test#php#behat#build_position(type, position) abort
  if a:type == 'nearest'
    let name = s:nearest_test(a:position)
    if !empty(name) | let name = '--name '.shellescape(name, 1) | endif
    return [a:position['file'], name]
  elseif a:type == 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#php#behat#build_args(args) abort
  return a:args
endfunction

function! test#php#behat#executable() abort
  if filereadable('./bin/behat')
    return './bin/behat'
  else
    return 'behat'
  endif
endfunction

function! s:nearest_test(position)
  let patterns = {'test': ['\vScenario: (.*)'], 'namespace': []}
  let name = test#base#nearest_test(a:position, patterns)
  return join(name['test'])
endfunction
