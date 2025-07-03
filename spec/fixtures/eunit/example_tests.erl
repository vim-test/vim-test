-module(example_tests).

-include_lib("eunit/include/eunit.hrl").

simple_test() ->
    ?assert(true).

generator_test_() ->
    [?_assert(true)].
