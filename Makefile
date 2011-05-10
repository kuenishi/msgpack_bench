.PHONY: compile xref eunit clean doc check make deps

all: compile xref eunit

# for busy typos
m: all
ma: all
mak: all
make: all

deps: rebar.config
	@./rebar get-deps

compile: deps
	@./rebar compile

xref:
	@./rebar xref

eunit:
	@./rebar eunit

clean:
	@./rebar clean

doc:
	@./rebar doc

check:
	@echo "you need ./rebar build-plt before make check"
# @./rebar build-plt
	@./rebar check-plt
	@./rebar dialyze

crosslang:
	@echo "do ERL_LIBS=../ before you make crosslang or fail"
	cd test && make crosslang

distclean: clean
	@rm -rf basho_bench deps

results:
	priv/summary.r -i tests/current
