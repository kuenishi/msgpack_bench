%%%-------------------------------------------------------------------
%%% @author UENISHI Kota <uenishi.kota@lab.ntt.co.jp>
%%% @copyright (C) 2011, UENISHI Kota
%%% @doc
%%%
%%% @end
%%% Created : 10 May 2011 by UENISHI Kota <uenishi.kota@lab.ntt.co.jp>
%%%-------------------------------------------------------------------
-module(msgpack_bench).

-compile(export_all).

start()->
    application:start(msgpack_bench).

stop()->
    application:stop(msgpack_bench).
