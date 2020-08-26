if !exists('g:test#javascript#ava#file_pattern')
  let g:test#javascript#ava#file_pattern = '\vtests?/.*\.(js|jsx|coffee)$'
endif

function! test#javascript#ava#test_file(file) abort
  if a:file =~# g:test#javascript#ava#file_pattern
      if exists('g:test#javascript#runner')
          return g:test#javascript#runner ==# 'ava'
      else
        return test#javascript#has_package('ava')
      endif
  endif
endfunction

function! test#javascript#ava#build_position(type, position) abort
  if a:type == 'nearest'
    let name = s:nearest_test(a:position)
    if !empty(name)
      let name = '--match='.shellescape(name, 1)
    endif
    return [a:position['file'], name]
  elseif a:type == 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#javascript#ava#build_args(args, color) abort
  let args = a:args

  if !a:color
    let args = ['--no-color'] + args
  endif

  return args
endfunction

function! test#javascript#ava#executable() abort
  if filereadable('node_modules/.bin/ava')
    return 'node_modules/.bin/ava'
  else
    return 'ava'
  endif
endfunction

function! s:nearest_test(position)
  let name = test#base#nearest_test(a:position, g:test#javascript#patterns)
  return test#base#escape_regex(join(name['namespace'] + name['test']))
endfunction
