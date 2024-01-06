if !exists('g:test#go#gotest#file_pattern')
  let g:test#go#gotest#file_pattern = '\v[^_].*_test\.go$'
endif

if !exists('g:test#go#gotest#testify#enabled')
  let g:test#go#gotest#testify#enabled = 0
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
       
      if g:test#go#gotest#testify#enabled == 1 && s:is_testify() == 1
          let suite_name = s:get_suite_name()
          let name = s:nearest_test(a:position)
          return empty(name) ? [] : [path, '-run '.shellescape(suite_name.'$') . ' -testify.m ' .shellescape(name, 1)]
      endif
      let name = s:nearest_test(a:position)
      return empty(name) ? [] : ['-run '.shellescape(name.'$', 1), path]
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

function! s:get_suite_name() abort
  for line in getline(1, "$")
      let suite_matched = matchlist(line, '\v^\s*func ((Test|Example).*)\(.*testing\.T')
      if len(suite_matched) > 1
          return filter(suite_matched, '!empty(v:val)')[1]
      endif
  endfor
  return ""
endfunction

function! s:nearest_test(position) abort
  let name = test#base#nearest_test(a:position, g:test#go#patterns)
  let name = join(name['namespace'] + name['test'], '/')
  let without_spaces = substitute(name, '\s', '_', 'g')
  let escaped_regex = substitute(without_spaces, '\([\[\].*+?|$^()]\)', '\\\1', 'g')
  return escaped_regex
endfunction

