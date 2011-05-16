%%%-------------------------------------------------------------------
%%% @author UENISHI Kota <uenishi.kota@lab.ntt.co.jp>
%%% @copyright (C) 2011, UENISHI Kota
%%% @doc
%%%
%%% @end
%%% Created : 10 May 2011 by UENISHI Kota <uenishi.kota@lab.ntt.co.jp>
%%%-------------------------------------------------------------------
-module(basho_bench_driver_protobuf).
-export([new/1, run/4]).

-include_lib("basho_bench/include/basho_bench.hrl").

new(_Id)->
    %% Make sure the path is setup such that we can get at riak_client
    case code:which(mprc) of
        non_existing ->
            ?FAIL_MSG("~s requires mprc module to be available on code path.\n",
                      [?MODULE]);
        _ ->
            ok
    end,
    try mprc:start() catch _:_ -> ok end,

    Server = basho_bench_config:get(msgpack_server),
    Port = basho_bench_config:get(msgpack_port),

    {ok, MPRC} = mprc:connect(Server, Port, [tcp]),
    {ok, MPRC}.

run(_, _KeyGen, _ValueGen, State)->
%    Key = 
    MPRC = State,
    {{ok,354}, _} = mprc:call(MPRC, add, [120, 234]),
    {ok, State}.
