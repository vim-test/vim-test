if !exists('g:test#clojure#fireplacetest#file_pattern')
  let g:test#clojure#fireplacetest#file_pattern = '\v(_test|^test/.+)\.cljs?$'
end

function! test#clojure#fireplacetest#test_file(file) abort
  return a:file =~# g:test#clojure#fireplacetest#file_pattern
endfunction

function! test#clojure#fireplacetest#build_position(type, position) abort
  call s:require_fireplace()

  if a:type ==# 'nearest'
    if expand('%:.') == a:position['file']
      return [':.RunTests']
    else
      return [':edit +'.a:position['line'].' '.a:position['file'].' | :.RunTests']
    endif
  elseif a:type ==# 'file'
    return [':RunTests '.fireplace#ns(a:position['file'])]
  else
    return [':0RunTests']
  endif
endfunction

function! test#clojure#fireplacetest#build_args(args) abort
  if get(a:args, 0, '') =~# 'RunTests'
    return a:args
  else
    return [':RunTests '.join(a:args)]
  endif
endfunction

function! test#clojure#fireplacetest#executable() abort
endfunction

function! s:require_fireplace() abort
  if !exists('g:loaded_fireplace')
    throw 'Test.vim requires Fireplace.vim to run Clojure tests'
  endif
endfunction
