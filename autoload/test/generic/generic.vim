" Returns true if the given file belongs to your test runner
function! test#generic#generic#get_vimtest_json(directory) abort
  let l:file = a:directory .. '/.vimtest.json'
  if filereadable(l:file)
    return l:file
  endif

  let l:directory = fnamemodify(a:directory, ':h')
  if l:directory !=# a:directory
    return test#generic#generic#get_vimtest_json(l:directory)
  else
    return ''
  endif
endfunction

function! test#generic#generic#test_file(file) abort
  let l:directory = fnamemodify(a:file, ':p:h')
  let s:vimtest_json = test#generic#generic#get_vimtest_json(l:directory)
  return s:vimtest_json !=# ''
endfunction

" Returns test runner's arguments which will run the current file and/or lin
function! test#generic#generic#build_position(type, position) abort
  " TODO: Support position
  let s:type = a:type
  return []
endfunction

" Returns processed args (if you need to do any processing)
function! test#generic#generic#build_args(args) abort
  return a:args
endfunction

" Returns the executable of your test runner
function! test#generic#generic#executable() abort
  " TODO: Cache JSON content with modified date
  let l:json = json_decode(readfile(s:vimtest_json))
  if has_key(l:json, s:type)
    let l:runner = l:json[s:type]
  elseif has_key(l:json, 'suite')
    let l:runner = l:json['suite']
  else
    echoerr print("'%s' has neither key '%s', nor 'suite'", s:vimtest_json, s:type)
    return ''
  endif

  if !has_key(l:runner, 'command')
    echoerr print("'%s' is missing key 'command' for '%s'", s:vimtest_json, s:type)
    return ''
  endif

  let l:command = []
  if has_key(l:runner, 'workdir')
    let l:workdir = fnamemodify(s:vimtest_json, ':h') .. '/' .. l:runner['workdir']
    " TODO: May need to escape if workdir contains single quotes
    let l:command += [ printf("cd '%s'", l:workdir) ]
  endif

  " TODO: Expand position into command if desired
  let l:command += [ l:runner['command'] ]

  return join(l:command, ' && ')
endfunction

