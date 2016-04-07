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
    let filename = ''
    let args = []
    let test_args = []

    if len(a:args)
        " total hack, will cause problems if last test_arg is a file in test_dir
        let last_index = len(a:args) - 1
        if test#perl#prove#test_file(a:args[-1]) || test#base#file_exists(a:args[-1])
            let filename = a:args[-1]
            let last_index = len(a:args) - 2
        endif

        for idx in range(0, last_index)
            if a:args[idx] == '::' || !empty(test_args) 
                call add(test_args, a:args[idx])
            else
                call add(args, a:args[idx])
            endif
        endfor
    endif

    if !len(filename)
        let filename = g:test#perl#prove#test_dir
    endif

    let args = args + [filename] + test_args

    if test#base#no_colors()
        let args = ['--nocolor'] + args
    endif

    return args
endfunction

function! test#perl#prove#executable()
  return 'prove -l'
endfunction
