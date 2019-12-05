function! s:TestAddition() abort
  call testify#assert#equals(2, 1 + 1)
endfunction
call testify#it('Adding 1 and 1 should give 2', function('s:TestAddition'))

function! s:TestSubtraction() abort
  call testify#assert#equals(0, 1 - 1)
endfunction
call testify#it('Subtracting 1 and 1 should give 0', function('s:TestSubtraction'))
