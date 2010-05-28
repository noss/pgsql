#!/usr/bin/env escript

main([ConfigFile]) ->
    {ok, Config} = file:consult(ConfigFile),
    {Host, Database, User, Login} = proplists:get_value(db, Config),

    {ok, Db} = pgsql:connect(Host, Database, User, Login),
    {ok, _} = pgsql:squery(Db, "DROP TABLE squery"),
    {ok, _} = pgsql:squery(Db, "CREATE TABLE squery (a varchar, b int)"),
    {ok, _} = pgsql:squery(Db, "INSERT INTO squery (a,b) VALUES ('Hello', 42)"),
    {ok, Responses} = pgsql:squery(Db, "SELECT a,b FROM squery"),
    [Response] = Responses, % Only one query issued
    {"SELECT", _Columns, Rows} = Response,
    [Row] = Rows, % Should only be one row in result
    {<<"Hello">>, 42} = Row,
    erlang:display({success, escript:script_name()}),
    ok.

