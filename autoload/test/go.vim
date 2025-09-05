let test#go#patterns = {
  \ 'test': [
    \ '\v^\s*func ((Test|Example).*)\(',
    \ '\v^\s*func \(.*\) ((Test).*)\(',
    \ '\v^\s*t\.Run\("(.*)"',
  \],
  \ 'namespace': [
    \ '\v^\s*func ((Test).*)\(',
    \ '\v^\s*t\.Run\("(.*)"',
  \],
\}

let s:original_testcase_pattern = '\v^\s*func ((Test|Example).*)\(.*testing\.T'

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


function! test#go#is_testify() abort
  for line in getline(1, "$")
      let testify_matched = matchlist(line, ".*testify\/suite.*")
      if len(testify_matched) > 0
          return 1
      endif
  endfor
  return 0
endfunction

function! test#go#get_suite_testcase_name(suite_name) abort
  let current_line = 1
  let current_testcase_name = ""
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

function! test#go#nearest_suite_name(position) abort
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
