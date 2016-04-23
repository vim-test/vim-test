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
endfunction

function! test#javascript#intern#build_position(type, position) abort
  let filename = fnamemodify(a:position['file'], ':r')
  if  filename =~# '\vtests?/functional/.*$'
    let suite = 'functionalSuites=' . filename
  else
    let suite = 'suites=' . filename
  endif

  if a:type == 'nearest'
    let name = s:nearest_test(a:position)
    if !empty(name)
      return [suite, 'grep=' . shellescape(name, 1)]
    else
      return [suite]
    endif
  elseif a:type == 'file'
    return [suite]
  else
    return []
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

function! s:nearest_test(position)
  let name = test#base#nearest_test(a:position, g:test#javascript#patterns)
  return join(name['namespace'] + name['test'], ' - ')
endfunction
