-module(test_SUITE).
-compile([export_all, nowarn_export_all]).

all() ->
    [t_foo, test_foo].

t_foo(_Config) ->
    ok.

test_foo(_Config) ->
    ok.
