
.PHONY: all test clean

all:
	@cd src && erl -make

test:
	@cd test && erl -make
	@erl -noshell -pa test \
         -eval 'eunit:test({dir, "test"}, [verbose]).' \
         -s init stop

clean:
	rm -f ebin/*.beam
	rm -f test/*.beam
