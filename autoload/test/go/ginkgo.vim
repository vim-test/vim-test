if !exists('g:test#go#ginkgo#file_pattern')
  let g:test#go#ginkgo#file_pattern = '\v[^_].*test\.go$'
endif
let test#go#ginkgo#patterns = {
  \ 'test': ['\v^\s*It\("(.*)",', '\v^\s*Context\("(.*)",', '\v.*Describe\("(.*)",'],
  \ 'namespace': [],
\}

function! test#go#ginkgo#test_file(file) abort
  return test#go#test_file('ginkgo', g:test#go#ginkgo#file_pattern, a:file)
endfunction

function! test#go#ginkgo#build_position(type, position) abort
  if a:type ==# 'suite'
    return ['./...']
  else
    let fileargs = ['--regexScansFilePath=true '.'--focus='.a:position['file']]
    if a:type ==# 'file'
      return fileargs
    elseif a:type ==# 'nearest'
      let path = './'.fnamemodify(a:position['file'], ':h')
      let name = s:nearest_test(a:position)
      " if no tests matched, run the test file
      return empty(name) ? fileargs : ['--focus='.shellescape(name, 1), path]
    endif
  endif
endfunction

function! test#go#ginkgo#build_args(args) abort
  let args = a:args

  if test#base#no_colors()
    let args = ['--nocolor'] + args
  endif

  return args
endfunction

function! test#go#ginkgo#executable() abort
  return 'ginkgo'
endfunction

function! s:nearest_test(position) abort
  let name = test#base#nearest_test(a:position, g:test#go#ginkgo#patterns)
  return get(name['test'], 0, '')
endfunction
