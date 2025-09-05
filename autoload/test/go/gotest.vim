if !exists('g:test#go#gotest#file_pattern')
  let g:test#go#gotest#file_pattern = '\v[^_].*_test\.go$'
endif

function! test#go#gotest#test_file(file) abort
  return test#go#test_file('gotest', g:test#go#gotest#file_pattern, a:file)
endfunction

function! test#go#gotest#build_position(type, position) abort
  let l:gotest_args = ''
  if exists('g:test#go#gotest#args')
    let l:gotest_args = '-args ' . g:test#go#gotest#args
  endif

  if a:type ==# 'suite'
    return ['./...', l:gotest_args]
  else
    let path = './'.fnamemodify(a:position['file'], ':h')

    if a:type ==# 'file'
      return path ==# './.' ? [] : [path . '/...']
    elseif a:type ==# 'nearest'
      if test#go#is_testify() == 1
        let suite_name = test#go#nearest_suite_name(a:position)
        if !empty(suite_name) 
          let suite_testcase_name = test#go#get_suite_testcase_name(suite_name)
          let name = s:nearest_test(a:position)
          return empty(name) ? [] : [path, '-run '.shellescape(suite_testcase_name.'$') . ' -testify.m ' .shellescape(name, 1)]
        endif
      endif
      let name = s:nearest_test(a:position)
      let command = empty(name) ? [] : ['-run '.shellescape(name.'$', 1), path]
      return add(command, l:gotest_args)
    endif
  endif
endfunction

function! test#go#gotest#build_args(args) abort
  if index(a:args, './...') >= 0
    return a:args
  endif
  let tags = []
  let index = 1
  let pattern = '^//\s*\%(go:build\|+build\)\s\+\(.\+\)'
  while index <= getbufinfo('%')[0]['linecount']
    let line = trim(getbufline('%', l:index)[0])
    if l:line =~# '^package '
      break
    endif
    let tag = substitute(line, l:pattern, '\1', '')
    if l:tag != l:line
      " replace OR tags with AND, since we are going to use all the tags anyway
      let tag = substitute(l:tag, '\v\&\&|\|\||\(|\)', '', 'g')
      for val in split(l:tag, '[, ]\+')
        if index(l:tags, l:val) == -1
          call add(l:tags, l:val)
        endif
      endfor
    endif
    let index += 1
  endwhile
  if len(l:tags) == 0
    return a:args
  else
    let args = ['-tags=' . join(l:tags, ',')] + a:args
    return l:args
  endif
endfunction

function! test#go#gotest#executable() abort
  return 'go test'
endfunction

function! s:nearest_test(position) abort
  let name = test#base#nearest_test(a:position, g:test#go#patterns)
  let name = join(name['namespace'] + name['test'], '/')
  let without_spaces = substitute(name, '\s', '_', 'g')
  let escaped_regex = substitute(without_spaces, '\([\[\].*+?|$^()]\)', '\\\1', 'g')
  return escaped_regex
endfunction
