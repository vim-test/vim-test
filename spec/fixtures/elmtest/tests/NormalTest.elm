module NormalTest exposing (..)

import Expect exposing (Expectation)
import Test exposing (..)


suite : Test
suite =
    describe "Testing things"
        [ test "equality works" <|
            \_ ->
                Expect.equal "something" "something"
        ]
