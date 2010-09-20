
-record(desc, {column, name, type, format, size, mod, table}).

% default timeout when interacting with database
-define(TIMEOUT, 5000).
