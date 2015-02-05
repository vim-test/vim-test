function! test#base#test_file(runner, file) abort
  return test#{a:runner}#test_file(a:file)
endfunction

function! test#base#build_position(runner, type, position) abort
  return test#{a:runner}#build_position(a:type, a:position)
endfunction

function! test#base#options(runner, ...) abort
  let options = get(g:, 'test#'.a:runner.'#options')
  if empty(a:000) && type(options) == type('')
    return options
  elseif !empty(a:000) && type(options) == type({})
    return get(options, a:000[0])
  endif
endfunction

function! test#base#executable(runner) abort
  return get(g:, 'test#'.a:runner.'#executable', test#{a:runner}#executable())
endfunction

function! test#base#build_args(runner, args) abort
  return test#{a:runner}#build_args(a:args)
endfunction

function! test#base#file_exists(file) abort
  return !empty(glob(a:file)) || bufexists(a:file)
endfunction

function! test#base#nearest_test(position, levels) abort
  let test_regex = get(a:levels, 0)
  let test = []

  let namespace_regex = get(a:levels, 1)
  let namespace = []

  let last_indent = -1

  for line in reverse(getbufline(a:position['file'], 1, a:position['line']))
    let test_match      = matchlist(line, test_regex)
    let namespace_match = matchlist(line, namespace_regex)

    let indent = len(matchstr(line, '^\s*'))
    if !empty(test_match) && last_indent == -1
      call add(test, filter(test_match[1:], '!empty(v:val)')[0])
      let last_indent = indent
    elseif !empty(namespace_match) && (indent < last_indent || last_indent == -1)
      call add(namespace, filter(namespace_match[1:], '!empty(v:val)')[0])
      let last_indent = indent
    endif
  endfor

  let namespace = map(reverse(namespace), 's:escape_regex(v:val)')
  let test      = map(test, 's:escape_regex(v:val)')

  return [namespace, test]
endfunction

function! s:escape_regex(string) abort
  return escape(a:string, '?+*\^$.|{}[]()')
endfunction
