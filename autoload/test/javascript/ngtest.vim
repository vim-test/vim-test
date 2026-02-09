if !exists('g:test#javascript#ngtest#file_pattern')
  let g:test#javascript#ngtest#file_pattern = '\v(test|spec)\.(js|jsx|ts|tsx)$'
endif

function! test#javascript#ngtest#test_file(file) abort
  if a:file =~# g:test#javascript#ngtest#file_pattern
      if exists('g:test#javascript#runner')
          return g:test#javascript#runner ==# 'ngtest'
      else
        return test#javascript#has_package('@angular/cli')
      endif
  endif
endfunction

function! test#javascript#ngtest#build_args(args) abort
  return a:args
endfunction

function! test#javascript#ngtest#build_position(type, position) abort
  if a:type ==# 'nearest'
    let name = s:nearest_test(a:position)
    let file = a:position['file']
    if !empty(name)
      return ['--include=' . shellescape(file, 1), '--filter=' . shellescape(name, 1)]
    else
      return ['--include=' . shellescape(file, 1)]
    endif
  elseif a:type ==# 'file'
    let file = a:position['file']
    return ['--include=' . shellescape(file, 1)]
  else
    return []
  endif
endfunction

function! test#javascript#ngtest#executable() abort
  return 'ng test'
endfunction

function! s:nearest_test(position) abort
  let name = test#base#nearest_test(a:position, g:test#javascript#patterns)
  return join(name['namespace'] + name['test'])
endfunction
