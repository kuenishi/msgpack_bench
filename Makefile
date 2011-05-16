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
# basho_bench fails
#	@./rebar xref

eunit:
# ibrowse fails
#	@./rebar eunit

thrift:
	cd priv/thrift && thrift --gen erl bench.thrift
	cd priv/thrift/gen-erl && erl -make
	cd priv/thrift && erl -make
	mv priv/thrift/gen-erl/*.beam ebin/

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

bench: compile
	./deps/basho_bench/basho_bench msgpack.config

results:
	priv/summary.r -i tests/current
