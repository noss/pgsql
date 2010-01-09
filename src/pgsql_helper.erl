-module(pgsql_helper).
-author('john@dryfish.org').

-export([prepare_insert/3, prepare_select/3, do_insert/2, transaction/3]).

join(_Sep, [ Head ]) ->
    Head;
join(Sep, [ Head | Tail ]) ->
    Head ++ Sep ++ join(Sep, Tail).

times(1, Of) ->
    [ Of ];
times(N, Of) ->
    [ Of ] ++ times(N - 1, Of).

columns(I, I) ->
    "$" ++ integer_to_list(I);
columns(I, N) ->
    "$" ++ integer_to_list(I) ++ ", " ++ columns(I + 1, N).

prepare_insert(Db, Name, Fields) ->
    StmtName = list_to_atom("insert_" ++ atom_to_list(Name)),
    StmtSQL = "INSERT INTO " ++ atom_to_list(Name)
        ++ " (" ++ join(", ", lists:map(fun(A) -> atom_to_list(A) end, Fields))
        ++ ") VALUES (" ++ columns(1, length(Fields)) ++ ")",
    pgsql:prepare(Db, StmtName, StmtSQL).

prepare_select(Db, Name, Fields) ->
    StmtName = list_to_atom("select_" ++ Name),
    StmtSQL = "SELECT " ++ join(", ", Fields) ++ " FROM " ++ Name,
    pgsql:prepare(Db, StmtName, StmtSQL).

any_to_list(Any) when is_float(Any) ->
    float_to_list(Any);
any_to_list(Any) when is_integer(Any) ->
    integer_to_list(Any);
any_to_list(Any) when is_atom(Any) ->
    atom_to_list(Any);
any_to_list(Any) ->
    Any.

do_insert(Db, Record) ->
    [ Name | Values ] = tuple_to_list(Record),
    StmtName = list_to_atom("insert_" ++ atom_to_list(Name)),
    pgsql:execute(Db, StmtName, lists:map(Values)).

transaction(Db, Fun, Args) ->
    {ok, _} = pgsql:squery(Db, "BEGIN WORK;"),
    Return = apply(Fun, Args),
    case Return of
        {'EXIT', _Term} -> 
            {ok, _Query} = pgsql:squery(Db, "ROLLBACK WORK;"),
            {rollback, Return};
        _Else ->
            {ok, _} = pgsql:squery(Db, "COMMIT WORK;"),
            {commit, Return}
    end.
