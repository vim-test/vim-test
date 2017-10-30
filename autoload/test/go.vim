let test#go#patterns = {
  \ 'test':      ['\v^\s*func (\w+)'],
  \ 'namespace': [],
\}
function! test#go#test_file(runner, file_pattern, file) abort
  if fnamemodify(a:file, ':t') =~# a:file_pattern
    " given the current runner, check if is can be used with the file
    if exists('g:test#go#runner')
      return a:runner == g:test#go#runner
    endif
    let contains_ginkgo_import = (search('github.com/onsi/ginkgo', 'n') > 0)
    if a:runner ==# 'ginkgo'
      return contains_ginkgo_import
    else
      return !contains_ginkgo_import
    endif
  endif
endfunction
