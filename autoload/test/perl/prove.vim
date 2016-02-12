if !exists('g:test#perl#prove#file_pattern')
  let g:test#perl#prove#file_pattern = '\v^t/.*\.t$'
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
  let out_args = a:args
  if len(a:args) == 2 
    let args = split(a:args[0], '::')
        
    if test#base#no_colors()
      let args[0] = ['--nocolor'] + args[0]
    endif
        
    if test#base#verbose()
      let args[0] = ['--verbose']  + args[0]
    endif
        
    let out_args = [args[0], a:args[1]]
    if len(args[1])
      let out_args = out_args + ['::', args[1]]
    endif
  endif

  if !empty(filter(copy(args), 'isdirectory(v:val)'))
    let out_args = ['--recurse'] + args
  endif

  return out_args
endfunction

function! test#perl#prove#executable()
  return 'prove -l'
endfunction
