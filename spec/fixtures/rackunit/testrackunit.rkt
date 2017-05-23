#lang racket

(require rackunit)

;Note that racket (as far as I can tell), is incapable
;of running the :TestSuite command.
;This means that :TestFile is pretty much the only command
;that can be ran.
(check-equal? 4 4)
(check-equal? 4 (+ 2 2))
(check-equal? "This is my string" "This is my string")

(test-case
  "List has a length of 4"
  (let ([lst (list 2 4 6 9)])
    (check = (length lst) 4)))
