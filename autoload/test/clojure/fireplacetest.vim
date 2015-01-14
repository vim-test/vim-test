function! test#clojure#fireplacetest#test_file(file) abort
  return a:file =~# '\v_test\.cljs?$' || a:file =~# '\v^test/.+\.cljs?$'
endfunction

function! test#clojure#fireplacetest#build_position(type, position) abort
  call s:require_fireplace()

  if a:type == 'nearest'
    let name = s:nearest_test(a:position)
    let ns = "'".fireplace#ns(a:position['file'])
    if !empty(name)
      return ['(clojure.test/test-vars [#'.ns.'/'.name.'])', s:reload([ns])]
    else
      return ['(clojure.test/run-tests '.ns.')', s:reload([ns])]
    endif
  elseif a:type == 'file'
    let ns = "'".fireplace#ns(a:position['file'])
    return ['(clojure.test/run-tests '.ns.')', s:reload([ns])]
  else
    return ['(clojure.test/run-all-tests)']
  endif
endfunction

function! test#clojure#fireplacetest#build_args(args) abort
  call s:require_fireplace()

  let args = a:args
  if empty(a:args)
    let args = ['(clojure.test/run-all-tests)']
  elseif a:args[0] !~# '^(clojure.test'
    if a:args[0] =~# '^/.\+/$'
      let regex = matchlist(a:args[0], '\v^/(.+)/$')[1]
      let args = ['(clojure.test/run-all-tests #"'.regex.'")']
    else
      let reqs = map(copy(a:args), '"''".fireplace#ns(v:val)')
      let args = [join(['(clojure.test/run-tests'] + reqs).')', s:reload(reqs)]
    end
  endif

  let expr = escape(args[0], '"')
  let pre = escape(get(args, 1, ''), '"')

  let cmd = 'call fireplace#capture_test_run("'.expr.'","'.pre.'")'
  let echo = 'echo "'.expr.'"'

  return [':'.join([cmd, echo], ' | ')]
endfunction

function! test#clojure#fireplacetest#executable() abort
  return ''
endfunction

function! s:nearest_test(position) abort
  let name = test#base#nearest_test(a:position, g:test#clojure#levels)
  return join(name[1])
endfunction

function! s:require_fireplace() abort
  if !exists('g:loaded_fireplace')
    throw "Test.vim requires Fireplace.vim to run Clojure tests"
  endif
endfunction

function! s:reload(reqs) abort
  return '(clojure.core/require '.join(a:reqs).' :reload-all) '
endfunction
