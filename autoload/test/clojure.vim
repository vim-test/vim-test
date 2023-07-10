" From https://clojure.org/reference/reader#_symbols
let s:symbol_chars = "0-9a-zA-Z-*+!_'?<>="

let test#clojure#patterns = {
  \ 'test':      ['(deftest \(['.s:symbol_chars.']\+\)'],
  \ 'namespace': ['(ns \(['.s:symbol_chars.'.]\+\)'],
  \}
