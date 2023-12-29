if !exists('g:test#clojure#leintest#file_pattern')
  let g:test#clojure#leintest#file_pattern = '\v(_test|^test/.+)\.clj[s]?$'
end

function! test#clojure#leintest#test_file(file) abort
  if exists('g:test#clojure#runner') && g:test#clojure#runner ==# 'leintest'
    return 1
  elseif exists("g:test#clojure#runner") && g:test#clojure#runner != 'leintest'
    return 0
  endif
  let l:project_clj = findfile('project.clj', fnamemodify(a:file, ':p').';')
  return !empty(l:project_clj) && a:file =~# g:test#clojure#leintest#file_pattern
endfunction

function! test#clojure#leintest#build_position(type, position) abort
  let l:info = test#base#nearest_test(a:position, g:test#clojure#patterns, {'namespaces_with_same_indent': v:true})
  if a:type ==# 'nearest'
    if !empty(l:info['namespace']) && !empty(l:info['test'])
      return [':only', shellescape(l:info['namespace'][0].'/'.l:info['test'][0])]
    else
      throw 'No test found'
    endif
  elseif a:type ==# 'file'
    if !empty(l:info['namespace'])
      return [':only', shellescape(l:info['namespace'][0])]
    else
      throw 'No namespace found'
    endif
  else
    return [':all']
  endif
endfunction

function! test#clojure#leintest#build_args(args) abort
  return a:args
endfunction

function! test#clojure#leintest#executable() abort
  return 'lein test'
endfunction
