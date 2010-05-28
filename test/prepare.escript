#!/usr/bin/env escript

main([ConfigFile]) ->
    {ok, Config} = file:consult(ConfigFile),
    {Host, Database, User, Login} = proplists:get_value(db, Config),

    {ok, Db} = pgsql:connect(Host, Database, User, Login),
    {ok, _} = pgsql:squery(Db, "DROP TABLE foo"),
    {ok, _} = pgsql:squery(Db, "CREATE TABLE foo (a varchar, b int)"),

    %% Prepare two statements
    {ok, idle, InsertPTypes, InsertRTypes} = pgsql:prepare(Db, insert, 
        "INSERT INTO foo (a,b) VALUES ($1, $2)"),
    {ok, idle, SelectPTypes, SelectRTypes} = pgsql:prepare(Db, select,
        "SELECT a,b FROM foo WHERE b = $1"),

    %% Populate table with data
    ABs = [{"Hello", 42}, {"Bye", 1337}],
    [pgsql:execute(Db, insert, [A, B]) || {A,B} <- ABs],

    {ok, Result} = pgsql:execute(Db, select, [42]),
    {'SELECT', [Row]} = Result,
    ["Hello", 42] = Row,

    erlang:display({success, escript:script_name()}),
    ok.

