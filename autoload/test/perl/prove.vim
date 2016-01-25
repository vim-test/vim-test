if !exists('g:test#perl#prove#file_pattern')
      let g:test#perl#prove#file_pattern = '\vt/.*\.(t)$'
endif

" Returns true if the given file belongs to your test runner
function! test#perl#prove#test_file(file) abort
    return a:file =~# g:test#perl#prove#file_pattern
endfunction

" Returns test runner's arguments which will run the current file and/or line
function! test#perl#prove#build_position(type, position) abort
    if a:type == 'file'
        return [a:position['file']]
    else
        return []
    endif
endfunction

" Returns processed args (if you need to do any processing)
function! test#perl#prove#build_args(args)
    return a:args
endfunction

" Returns the executable of your test runner
function! test#perl#prove#executable()
    return 'prove -l'
endfunction
