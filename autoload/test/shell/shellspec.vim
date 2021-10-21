if !exists('g:test#shell#shellspec#file_pattern')
  let g:test#shell#shellspec#file_pattern = '_spec\.sh$'
endif

if !exists('g:test#shell#shellspec#patterns')
  let g:test#shell#shellspec#patterns = {
        \ 'test': [
        \ '\v^\s*\It %("|'')(.*)%("|'')'
        \ ],
        \ 'namespace': []
        \ }
endif

" Returns true if the given file belongs to your test runner
function! test#shell#shellspec#test_file(file) abort
  return a:file =~# g:test#shell#shellspec#file_pattern
endfunction

" Returns test runner's arguments which will run the current file and/or line
function! test#shell#shellspec#build_position(type, position) abort
  if a:type ==# 'nearest'
    let name = test#base#nearest_test(a:position, g:test#shell#shellspec#patterns)
    if empty(name['test'])
      return []
    else
      return [a:position['file'], '-E', ''''.name['test'][0].'''']
    endif
  elseif a:type ==# 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

" Returns processed args (if you need to do any processing)
function! test#shell#shellspec#build_args(args) abort
  if empty(filter(copy(a:args), 'test#base#file_exists(v:val)'))
    call add(a:args, 'spec/')
  endif

  return a:args
endfunction

" Returns the executable of your test runner
function! test#shell#shellspec#executable() abort
  return 'shellspec'
endfunction
