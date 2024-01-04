(ns math-test
  (:require [clojure.test :refer [deftest is]]
            [clojure.test.check.clojure-test :refer [defspec]]
            [clojure.test.check.generators :as gen]
            [clojure.test.check.properties :as prop]))

(deftest +-works
  (is (= 4 (+ 2 2))))

(clojure.test/deftest *-works
  (is (= 4 (* 2 2))))

(defspec +-is-commutative
  (prop/for-all [a gen/large-integer
                 b gen/large-integer]
                (= (+ a b) (+ b a))))

(clojure.test.check.clojure-test/defspec *-is-commutative
  (prop/for-all [a gen/small-integer
                 b gen/small-integer]
                (= (* a b) (* b a))))
