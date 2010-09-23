
.PHONY: all test clean install

VERSION = $(shell sed -n '/vsn/ {s/.*,\s*"\([0-9][0-9.]*\)".*/\1/; p}' \
                      pgsql.app.in)

PREFIX   ?= /usr
ERL_ROOT  = $(PREFIX)/lib/erlang
LIBDIR    = /lib
DISTDIR   = pgsql-$(VERSION)


all:
	cp -f pgsql.app.in ebin/pgsql.app
	@cd src && erl -make

test:
	escript test/squery.escript test/test.config
	escript test/pquery.escript test/test.config
	escript test/prepare.escript test/test.config
#	@cd test && erl -make
#	@erl -noshell -pa test \
#         -eval 'eunit:test({dir, "test"}, [verbose]).' \
#         -s init stop

clean:
	rm -f ebin/*.beam ebin/*.app
	rm -f test/*.beam

install:
	# create dist directory
	mkdir -p $(DESTDIR)$(ERL_ROOT)$(LIBDIR)/$(DISTDIR)
	# copy and install files
	cp -a ebin $(DESTDIR)$(ERL_ROOT)$(LIBDIR)/$(DISTDIR)
