if !exists('g:test#perl#prove#test_dir')
  let g:test#perl#prove#test_dir = 't'
endif

if !exists('g:test#perl#prove#file_pattern')
  let g:test#perl#prove#file_pattern = '\v^' . g:test#perl#prove#test_dir . '/.*\.t$'
endif

function! test#perl#prove#test_file(file) abort
  return a:file =~# g:test#perl#prove#file_pattern
endfunction

function! test#perl#prove#build_position(type, position) abort
  if a:type == 'file' || a:type == 'nearest'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#perl#prove#build_args(args)
    let options = ''
    let filename = ''
    let prove_args = []
    let test_args = []

    if len(a:args) == 2
        let options = a:args[0]
        let filename = a:args[1]
    elseif len(a:args) == 1
        if filereadable(a:args[0])
            let filename = a:args[0]
        else
            let options = a:args[0]
        endif
    endif

    if !empty(options)
        let parts = split(options, '::', 1)
        call add(prove_args, parts[0])
        if len(parts) == 2
            call extend(test_args, ['::', parts[1]])
        endif
    endif

    if empty(filename)
        let filename = g:test#perl#prove#test_dir
    endif

    if test#base#no_colors()
        let prove_args = ['--nocolor'] + prove_args
    endif

    let combined = extend(extend(prove_args, [filename]), test_args)
    return combined
endfunction

function! test#perl#prove#executable()
  return 'prove -l'
endfunction
