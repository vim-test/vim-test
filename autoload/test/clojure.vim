let s:line_start = '\v^\s*'
" From https://clojure.org/reference/reader#_symbols
let s:symbol_chars = "0-9a-zA-Z-*+!_'?<>="
let s:word = '['.s:symbol_chars.']+'
let s:ns_word = '['.s:symbol_chars.'.]+' " Namespaces can also have dots

" We want to support both referred and qualified references to a test
" definition function, i.e. both of these should work:
" 
"  (deftest ...)
"  (clojure.test/deftest ...)
"
function! s:patterns(name)
	let l:prefix = s:line_start.'\(\s*'
	let l:suffix = '\s+('.s:word.')'
	let l:qualified_name = s:ns_word.'\/'.a:name
	return [l:prefix.a:name.l:suffix, l:prefix.l:qualified_name.l:suffix]
endfunction

let test#clojure#patterns = {
  \ 'test':      s:patterns('deftest') + s:patterns('defspec'),
  \ 'namespace': [s:line_start.'\(ns\s+('.s:ns_word.')'],
  \}
