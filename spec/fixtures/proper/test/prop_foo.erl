-module(prop_foo).

-include_lib("proper/include/proper.hrl").

prop_bar() ->
    ?FORALL(T, number(), is_number(T)).

prop_baz() ->
    ?FORALL(T, binary(), is_binary(T)).
