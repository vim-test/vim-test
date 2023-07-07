if !exists('g:test#clojure#fireplacetest#file_pattern')
  let g:test#clojure#fireplacetest#file_pattern = '\v(_test|^test/.+)\.cljs?$'
end

function! test#clojure#fireplacetest#test_file(file) abort
  if exists('g:test#clojure#runner') && g:test#clojure#runner ==# 'fireplacetest'
    return 1
  elseif exists("g:test#clojure#runner") && g:test#clojure#runner != 'fireplacetest'
    return 0
  endif
  return s:has_fireplace() && a:file =~# g:test#clojure#fireplacetest#file_pattern
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
  if !s:has_fireplace()
    throw 'The fireplacetest runner requires Fireplace.vim to run Clojure tests'
  endif
endfunction

function! s:has_fireplace() abort
  return exists('g:loaded_fireplace')
endfunction
