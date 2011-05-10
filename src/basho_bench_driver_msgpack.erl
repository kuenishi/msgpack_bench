%%%-------------------------------------------------------------------
%%% @author UENISHI Kota <uenishi.kota@lab.ntt.co.jp>
%%% @copyright (C) 2011, UENISHI Kota
%%% @doc
%%%
%%% @end
%%% Created : 10 May 2011 by UENISHI Kota <uenishi.kota@lab.ntt.co.jp>
%%%-------------------------------------------------------------------
-module(basho_bench_driver_msgpack).
-export([new/1, run/4]).

% -include_lib("basho_bench/include/basho_bench.hrl").

new(_Id)->
    {ok, undefined}.

run(_, _KeyGen, _ValueGen, State)->
    {ok, State}.
