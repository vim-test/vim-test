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

function! test#base#escape_regex(string) abort
  return escape(a:string, '?+*\^$.|{}[]()')
endfunction

function! test#base#no_colors() abort
  let strategy = get(g:, 'test#strategy', 'basic')
  return has('gui_running') && strategy == 'basic'
endfunction

function! test#base#nearest_test(position, patterns) abort
  let test        = []
  let namespace   = []
  let last_indent = -1

  for line in reverse(getbufline(a:position['file'], 1, a:position['line']))
    let test_match      = s:find_match(line, a:patterns['test'])
    let namespace_match = s:find_match(line, a:patterns['namespace'])

    let indent = len(matchstr(line, '^\s*'))
    if !empty(test_match) && last_indent == -1
      call add(test, filter(test_match[1:], '!empty(v:val)')[0])
      let last_indent = indent
    elseif !empty(namespace_match) && (indent < last_indent || last_indent == -1)
      call add(namespace, filter(namespace_match[1:], '!empty(v:val)')[0])
      let last_indent = indent
    endif
  endfor

  return {'test': test, 'namespace': reverse(namespace)}
endfunction

function! s:find_match(line, patterns) abort
  let matches = map(copy(a:patterns), 'matchlist(a:line, v:val)')
  return get(filter(matches, '!empty(v:val)'), 0, [])
endfunction
