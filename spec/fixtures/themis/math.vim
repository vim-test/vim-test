let s:suite = themis#suite("math")
let s:assert = themis#helper("assert")

function! s:suite.addition() abort
  call s:assert.equal(2, 1 + 1)
endfunction

function! s:suite.subtraction() abort
  call s:assert.equal(0, 1 - 1)
endfunction
