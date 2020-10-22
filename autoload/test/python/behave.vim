if !exists('g:test#python#behave#file_pattern')
    let g:test#python#behave#file_pattern = '\v.feature$'
endif

function! test#python#behave#test_file(file) abort
    if a:file =~# g:test#python#behave#file_pattern
        return !empty(glob('features/**/*.py'))
    endif
endfunction

function! test#python#behave#build_position(type, position) abort
    if a:type ==# 'nearest'
        return [a:position['file'] . ':' . a:position['line']]
    elseif a:type ==# 'file'
        return [a:position['file']]
    else
        return []
    endif
endfunction

function! test#python#behave#build_args(args, color) abort
    let args = a:args

    if !a:color
        let args = ['--no-color'] + args
    endif

    return args
endfunction

function! test#python#behave#executable() abort
    return 'behave'
endfunction
