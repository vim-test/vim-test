function! test#_generic#vimtestjson#get_vimtest_json(directory) abort
  let l:file = a:directory .. '/.vimtest.json'
  if filereadable(l:file)
    return l:file
  endif

  let l:directory = fnamemodify(a:directory, ':h')
  if l:directory !=# a:directory
    return test#_generic#vimtestjson#get_vimtest_json(l:directory)
  else
    return ''
  endif
endfunction

function! test#_generic#vimtestjson#test_file(file) abort
  let l:directory = fnamemodify(a:file, ':p:h')
  let s:vimtest_json = test#_generic#vimtestjson#get_vimtest_json(l:directory)
  return s:vimtest_json !=# ''
endfunction

function! test#_generic#vimtestjson#build_position(type, position) abort
  return []
endfunction

function! test#_generic#vimtestjson#build_args(args) abort
  return a:args
endfunction

function! test#_generic#vimtestjson#executable() abort
  let l:json = readfile(s:vimtest_json)->join()->json_decode()
  return l:json['command']
endfunction

