-module(test_SUITE).
-compile([export_all, nowarn_export_all]).

all() ->
    [test_foo].

test_foo(_Config) ->
    ok.
