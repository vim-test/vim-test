if !exists('g:test#go#gotest#file_pattern')
  let g:test#go#gotest#file_pattern = '\v[^_].*_test\.go$'
endif

function! test#go#gotest#test_file(file) abort
  return test#go#test_file('gotest', g:test#go#gotest#file_pattern, a:file)
endfunction

let s:original_testcase_pattern = '\v^\s*func ((Test|Example).*)\(.*testing\.T'

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
      if s:is_testify() == 1
        let suite_name = s:nearest_suite_name(a:position)
        if !empty(suite_name) 
          let suite_testcase_name = s:get_suite_testcase_name(suite_name)
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

function! s:is_testify() abort
  for line in getline(1, "$")
      let testify_matched = matchlist(line, ".*testify\/suite.*")
      if len(testify_matched) > 0
          return 1
      endif
  endfor
  return 0
endfunction

function! s:get_suite_testcase_name(suite_name) abort
  let current_line = 1
  let current_testcase_name = ""
  let s:original_testcase_pattern = '\v^\s*func ((Test|Example).*)\(.*testing\.T'
  for line in getline(1, "$")
      let testcase_matched = matchlist(line, s:original_testcase_pattern)
      if len(testcase_matched) > 1
          let current_testcase_name = filter(testcase_matched, '!empty(v:val)')[1]
          " check if suite is in this testcase
          for line in getline(current_line + 1, "$")
              let current_testcase_run_suite_matched = matchlist(line, '.*'. a:suite_name.'.*')
              let another_testcase_matched = matchlist(line, s:original_testcase_pattern)

              if len(another_testcase_matched) > 1
                  break
              endif 

              if (len(current_testcase_run_suite_matched) > 0)
                  return current_testcase_name
              endif
          endfor
      endif
      let current_line += 1
  endfor
  return ""
endfunction

function! s:nearest_suite_name(position) abort
  for line in reverse(getline(1, a:position['line']))
      " find suite name from receiver
      let suite_matched = matchlist(line, '\v^\s*func\s*\(\s*\S*\s*\*?(\w+)\)\s*Test.*\(')
      let original_testcase_matched = matchlist(line, s:original_testcase_pattern)

      if len(original_testcase_matched) > 1
          return ''
      endif 

      if len(suite_matched) > 1
          return filter(suite_matched, '!empty(v:val)')[1]
      endif
  endfor
  return ''
endfunction

function! s:nearest_test(position) abort
  let name = test#base#nearest_test(a:position, g:test#go#patterns)
  let name = join(name['namespace'] + name['test'], '/')
  let without_spaces = substitute(name, '\s', '_', 'g')
  let escaped_regex = substitute(without_spaces, '\([\[\].*+?|$^()]\)', '\\\1', 'g')
  return escaped_regex
endfunction
