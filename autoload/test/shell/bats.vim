if !exists('g:test#shell#bats#file_pattern')
  let g:test#shell#bats#file_pattern = '\v\.bats$'
endif

if !exists('g:test#shell#bats#patterns')
  let g:test#shell#bats#patterns = {
        \ 'test': [
        \ '\v^\s*\@test %("|'')(.*)%("|'')'
        \ ],
        \ 'namespace': []
        \ }
endif

function! test#shell#bats#test_file(file) abort
  return a:file =~# g:test#shell#bats#file_pattern
endfunction

function! test#shell#bats#build_position(type, position) abort
  if a:type ==# 'nearest'
    let name = test#base#nearest_test(a:position, g:test#shell#bats#patterns)
    if empty(name['test'])
      return []
    else
      return [a:position['file'], '-f', '''^'.name['test'][0].'$''']
    endif
  elseif a:type ==# 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#shell#bats#build_args(args)
  if empty(filter(copy(a:args), 'test#base#file_exists(v:val)'))
    call add(a:args, 'test/')
  endif

  return a:args
endfunction

function! test#shell#bats#executable() abort
  return 'bats'
endfunction
