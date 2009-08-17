-module(insert_example).
-author('john@dryfish.org').

-export([test/0]).

-include("database_defs.hrl").

test() ->
    {ok, Db} = pgsql:connect(?HOST, ?DB, ?USER, ?PASS),
    {ok, Status, ParamTypes, ResultTypes}
        = pgsql:prepare(Db, dummynew, "INSERT INTO dummy (stuff) VALUES ($1)"),
    {ok,{'INSERT', NRows}} = pgsql:execute(Db, dummynew, ["canada goose"]),
    io:format("NRows: ~p~n", [NRows]).

