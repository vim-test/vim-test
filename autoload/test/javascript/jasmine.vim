if !exists('g:test#javascript#jasmine#file_pattern')
  let g:test#javascript#jasmine#file_pattern = '\v^spec[\\/].*spec\.(js|jsx|coffee)$'
endif

function! test#javascript#jasmine#test_file(file) abort
  if a:file =~? g:test#javascript#jasmine#file_pattern
      if exists('g:test#javascript#runner')
          return g:test#javascript#runner ==# 'jasmine'
      else
        return test#javascript#has_package('jasmine')
      endif
  endif
endfunction

function! test#javascript#jasmine#build_position(type, position) abort
  if a:type ==# 'nearest'
    let name = s:nearest_test(a:position)
    if !empty(name)
      let name = '--filter='.shellescape(name, 1)
    endif
    return [a:position['file'], name]
  elseif a:type ==# 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#javascript#jasmine#build_args(args, color) abort
  let args = a:args

  if !a:color
    let args = ['--no-color'] + args
  endif

  return args
endfunction

function! test#javascript#jasmine#executable() abort
  if filereadable('node_modules/.bin/jasmine')
    return expand('node_modules/.bin/jasmine')
  else
    return 'jasmine'
  endif
endfunction

function! s:nearest_test(position) abort
  let name = test#base#nearest_test(a:position, g:test#javascript#patterns)
  return join(name['namespace'] + name['test'])
endfunction
