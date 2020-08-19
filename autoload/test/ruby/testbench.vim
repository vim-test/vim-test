if !exists('g:test#ruby#testbench#file_pattern')
  let g:test#ruby#testbench#file_pattern = '\v(^|/)test/automated/.+\.rb$'
endif

function! test#ruby#testbench#test_file(file) abort
  return a:file =~# g:test#ruby#testbench#file_pattern
endfunction

function! test#ruby#testbench#build_position(type, position) abort
  " NOTE: TestBench does not currently support running a 'nearest' test
  if a:type ==# 'file' || a:type ==# 'nearest'
    return [a:position['file']]
  elseif a:type ==# 'suite'
    return ['test/automated/']
  else
    return []
  endif
endfunction

function! test#ruby#testbench#build_args(args) abort
  return a:args
endfunction

function! test#ruby#testbench#executable() abort
  if filereadable('Gemfile') && get(g:, 'test#ruby#bundle_exec', 1)
    return 'bundle exec bench'
  else
    return 'bench'
  endif
endfunction

