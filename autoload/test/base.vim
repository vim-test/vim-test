function! test#base#test_file(runner, file) abort
  return test#{a:runner}#test_file(a:file)
endfunction

function! test#base#build_position(runner, type, position) abort
  return test#{a:runner}#build_position(a:type, a:position)
endfunction

function! test#base#options(runner, args, ...) abort
  let options = get(g:, 'test#'.a:runner.'#options', [])
  if empty(a:000) && type(options) == type('')
    let options = split(options)
  elseif !empty(a:000) && type(options) == type({})
    let options = split(get(options, 'all', '')) + split(get(options, a:000[0], ''))
  else
    let options = []
  endif
  if exists('*test#'.a:runner.'#build_options')
    return test#{a:runner}#build_options(a:args, options)
  else
    return options + a:args
  endif
endfunction

function! test#base#executable(runner) abort
  if exists('g:test#'.a:runner.'#executable')
    return g:test#{a:runner}#executable
  else
    return test#{a:runner}#executable()
  endif
endfunction

function! test#base#build_args(runner, args, strategy) abort
  let no_color = has('gui_running') && a:strategy ==# 'basic'

  try
    " Before Vim 8.0.1423 exceptions thrown from return statement
    " cannot be caught.
    " https://github.com/vim/vim/pull/2483
    let args = test#{a:runner}#build_args(a:args, !no_color)
    return args
  catch /^Vim\%((\a\+)\)\=:E118:/ " too many arguments
    return test#{a:runner}#build_args(a:args)
  endtry
endfunction

function! test#base#file_exists(file) abort
  return !empty(glob(a:file)) || bufexists(a:file)
endfunction

function! test#base#escape_regex(string) abort
  return escape(a:string, '?+*\^$.|{}[]()')
endfunction

" Takes a position and a dictionary of patterns and a optional configuration, and returns list of strings
" that were matched in the file by the patterns from the given position
" upwards. It can be used when a runner doesn't support running nearest tests
" with line numbers, but supports regexes.
"
" The "position" argument is a dictionary created by this plugin:
"
"   {
"     'file': 'test/foo_test.rb',
"     'line': 11,
"     'col': 2,
"   }
"
" The "patterns" argument is a dictionary where keys are either "test" or
" "namespace", and values are lists of regexes:
"
"   {
"     'test': ['\v^\s*def (test_\w+)'],
"     'namespace': ['\v^\s*%(class|module) (\S+)'],
"   }
"
" The optional configuration parameter is a dictionary which can contain next
" keys:
"
"   {
"      'namespaces_with_same_indent': boolean // put namespace with same indent
"                                            // in "namespace output.
"   }
"
" If a line is matched, the substring corresponding to the 1st match group will
" be returned. So for the above patterns this function might return something
" like this:
"
"   {
"     'test': ['test_calculates_time'],
"     'test_line': 54, " Line where 'test_calculates_time' was found
"     'namespace': ['CalculatorTest'],
"   }
function! test#base#nearest_test(position, patterns, ...) abort
  let configuration = a:0 > 0 ? a:1 : {}
  return test#base#nearest_test_in_lines(a:position['file'], a:position['line'], 1, a:patterns, configuration)
endfunction

" This function is used internally by the test#base#nearest_test function
" So it behaves exactly like describe for test#base#nearest_test except that
" it can search forward or backward depending on the search range.
"
" Instead of taking a "position" argument, this function takes 3:
"   - "filename" is the equivalent of "position['file']"
"   - "from_line" the line number from where to start the search, is the
"   equivalent of "position['line']"
"   - "to_line" the line number where to end the search (it would be 1 in
"   test#base#nearest_test)
"
" If "from_line" is greater than "to_line" or equals '$' then the search will
" be backward.
" Otherwise it will be forward.
function! test#base#nearest_test_in_lines(filename, from_line, to_line, patterns, ...) abort
  let configuration = a:0 > 0 ? a:1 : {}
  let test         = []
  let namespace    = []
  let last_indent  = -1
  let current_line = a:from_line + 1
  let test_line    = -1
  let last_namespace_line = -1
  let is_namespace_with_same_indent_allowed = get(configuration, 'namespaces_with_same_indent', 0)

  let is_reverse = '$' == a:from_line ? 1 : a:from_line > a:to_line
  let lines = is_reverse
    \ ? reverse(getbufline(a:filename, a:to_line, a:from_line))
    \ : getbufline(a:filename, a:from_line, a:to_line)

  for line in lines
    let current_line    = current_line + (is_reverse ? -1 : 1)
    let test_match      = s:find_match(line, a:patterns['test'])
    let namespace_match = s:find_match(line, a:patterns['namespace'])

    let indent = len(matchstr(line, '^\s*'))
    if !empty(test_match) 
      \ && (last_indent == -1 
          \ || (test_line == -1 
              \ && last_indent > indent 
              \ && last_namespace_line > current_line 
              \ && last_namespace_line != -1
          \ )
        \ )
      if last_namespace_line > current_line 
        let namespace = []
        let last_namespace_line = -1
      endif
      call add(test, filter(test_match[1:], '!empty(v:val)')[0])
      let last_indent = indent
      let test_line   = current_line
    elseif !empty(namespace_match) && (is_namespace_with_same_indent_allowed || (indent < last_indent || last_indent == -1))
      call add(namespace, filter(namespace_match[1:], '!empty(v:val)')[0])
      let last_indent = indent
      let last_namespace_line = current_line
    endif
  endfor

  return {'test': test, 'test_line': test_line, 'namespace': reverse(namespace)}
endfunction

function! s:find_match(line, patterns) abort
  let matches = map(copy(a:patterns), 'matchlist(a:line, v:val)')
  return get(filter(matches, '!empty(v:val)'), 0, [])
endfunction
