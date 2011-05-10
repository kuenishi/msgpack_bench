
-module(msgpack_bench_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-include_lib("eunit/include/eunit.hrl").

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type, Argv), {I, {I, start_link, Argv}, permanent, 5000, Type, [I]}).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
    AChild = {msgpack_bench_srv,{mprs,start_link,[msgpack_bench_srv,[{host,localhost},{port,9199}]]},
     	      permanent,2000,worker,[msgpack_bench_srv]},
%    AChild = ?CHILD(mprs, worker,[msgpack_bench_srv,[{host,localhost},{port,9199}]]),
    ?debugVal(AChild),
    ok = supervisor:check_childspecs([AChild]),
    {ok, { {one_for_one, 5, 10}, [AChild]}}.
