%%%-------------------------------------------------------------------
%%% @author Vladimir Goncharov <viruzzz@lnb.local>
%%% @copyright (C) 2012, Vladimir Goncharov
%%% @doc
%%%
%%% @end
%%% Created :  8 Aug 2012 by Vladimir Goncharov <viruzzz@lnb.local>
%%%-------------------------------------------------------------------
-module(client_handler).

%% API
-export([handle_command/4]).

%%%===================================================================
%%% API
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------


%list_root_to_bin([]) ->
%    [];
%list_root_to_bin([{Id,Name}|Rest]) ->
%    binary_to_list(<<Id:32/big>>)++[Name,0]++list_root_to_bin(Rest).

handle_command(Command, Payload, _MsgId, _State) ->
    case Command of
	16#00 -> %% NOP
	    {ok};
	16#01 -> %% Ping
	    {ok, (Payload)};
	16#21 -> %% List DSes
	    {error, command_unimplemented};
	16#22 -> %% List Roots
	    {ok, List} = database_server:request_data(list_roots,[]),
%	    %{ok, lists:flatten(list_root_to_bin(List))};
	    {ok, List};
	_Any ->
	    {warn, unknown_command}
    end.


%%%===================================================================
%%% Internal functions
%%%===================================================================
