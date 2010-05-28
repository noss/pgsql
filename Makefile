
.PHONY: all test clean

all:
	cp -f pgsql.app.in ebin/pgsql.app
	@cd src && erl -make

test:
	escript test/squery.escript test/test.config
#	@cd test && erl -make
#	@erl -noshell -pa test \
#         -eval 'eunit:test({dir, "test"}, [verbose]).' \
#         -s init stop

clean:
	rm -f ebin/*.beam ebin/*.app
	rm -f test/*.beam
