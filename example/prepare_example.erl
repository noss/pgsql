-module(prepare_example).
-author('john@dryfish.org').

-export([test/0]).

-include("database_defs.hrl").

test() ->
    {ok, Db} = pgsql:connect(?HOST, ?DB, ?USER, ?PASS),
    {ok, Status, ParamTypes, ResultTypes}
        = pgsql:prepare(Db, dummyall, "SELECT id, stuff FROM dummy"),
    {ok,{'SELECT', ResultSet}} = pgsql:execute(Db, dummyall, []),
    io:format("ResultSet: ~p~n", [ResultSet]).

