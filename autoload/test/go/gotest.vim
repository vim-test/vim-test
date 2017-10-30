if !exists('g:test#go#gotest#file_pattern')
  let g:test#go#gotest#file_pattern = '\v[^_].*_test\.go$'
endif

function! test#go#gotest#test_file(file) abort
  return test#go#test_file('gotest', g:test#go#gotest#file_pattern, a:file)
endfunction

function! test#go#gotest#build_position(type, position) abort
  if a:type ==# 'suite'
    return ['./...']
  else
    let path = './'.fnamemodify(a:position['file'], ':h')

    if a:type ==# 'file'
      return path ==# './.' ? [] : [path . '/...']
    elseif a:type ==# 'nearest'
      let name = s:nearest_test(a:position)
      return empty(name) ? [] : ['-run '.shellescape(name.'$', 1), path]
    endif
  endif
endfunction

function! test#go#gotest#build_args(args) abort
  return a:args
endfunction

function! test#go#gotest#executable() abort
  return 'go test'
endfunction

function! s:nearest_test(position) abort
  let name = test#base#nearest_test(a:position, g:test#go#patterns)
  return join(name['test'])
endfunction
