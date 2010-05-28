#!/usr/bin/env escript

main([ConfigFile]) ->
    {ok, Config} = file:consult(ConfigFile),
    {Host, Database, User, Login} = proplists:get_value(db, Config),

    {ok, Db} = pgsql:connect(Host, Database, User, Login),
    {ok, _} = pgsql:squery(Db, "DROP TABLE pquery"),
    {ok, _} = pgsql:squery(Db, "CREATE TABLE pquery (a varchar, b int)"),
    {ok, _} = pgsql:squery(Db, "INSERT INTO pquery (a,b) VALUES ('Hello', 42)"),
    {ok, Command, Status, Cols, Rows} = 
        pgsql:pquery(Db, "SELECT a,b FROM pquery WHERE b = $1", [42]),

    "SELECT" = Command,
    idle = Status,
    [_ColA, _ColB] = Cols,
    [Row] = Rows,
    {<<"Hello">>, 42} = Row,

    erlang:display({success, escript:script_name()}),
    ok.

