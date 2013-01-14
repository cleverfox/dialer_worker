%%%-------------------------------------------------------------------
%%% @author Vladimir Goncharov <viruzzz@lnb.local>
%%% @copyright (C) 2012, Vladimir Goncharov
%%% @doc
%%%
%%% @end
%%% Created :  8 Aug 2012 by Vladimir Goncharov <viruzzz@lnb.local>
%%%-------------------------------------------------------------------
-module(fbp).

%% API
-export([packFBP/3,parseFBP/1,packIdMap/2,unpackIdMap/2]).

%%%===================================================================
%%% API
%%%===================================================================

packIdMapi ([],_) ->
    [];
packIdMapi ([{Key,Val}|Rest],Idlen) ->
    binary_to_list (<<Key:Idlen/big>>)++[Val,0]++packIdMap(Rest,Idlen).
packIdMap (List,IdLen) ->
    list_to_binary(packIdMapi(List,IdLen)).

z_split(B, N) -> 
    case B of 
   <<B1:N/binary,0,B2/binary>> -> 
       {B1,B2}; 
   <<_:N/binary>>=B -> 
       B; 
   <<_:N/binary,_/binary>>=B -> 
       z_split(B, N+1) 
    end.

unpackIdMap(<<>>,_) ->
    [];
unpackIdMap(B,IdLen) ->
    <<Key:IdLen/big,Rest/binary>> = B,
    %Len=(string:chr(binary_to_list(Rest),0)-1),
    %{<<Val>>,<<_Null:8,Next/binary>>} = split_binary(Rest,Len),
    {Val,Next} = z_split(Rest,0),
%    io:format("~p : ~p ~n",[Key,Val]),
    [{Key, binary_to_list(Val)} | unpackIdMap(Next,IdLen) ].

packFBP(MsgId,Command,Data) ->
    if is_binary(Data) ->
	    Len=size(Data),
	    <<MsgId:32/big,Command:16/big,Len:16/big,Data/binary>>;
       is_list(Data) ->
	    Len=length(Data),
	    list_to_binary(binary_to_list(<<MsgId:32/big,Command:16/big,Len:16/big>>)++Data);
       true ->
	    <<MsgId:32/big,Command:16/big,0:16/big>>
    end.


parseFBP (Data) ->
    if
	is_binary(Data) ->
	    case Data of
		<<MsgId:32/big,Command:16/big,Len:16/big,Payload/binary>> ->
		    case size(Payload) of
			Len ->
			    {MsgId,Command,Len,Payload};
			_Any ->
			    {error, message_corrupted}
		    end;
		_ ->
		    {error, cant_parse_binary}
	    end;
	is_list(Data) ->
	    case list_to_binary(Data) of
		<<MsgId:32/big,Command:16/big,Len:16/big,Payload/binary>> ->
		    case size(Payload) of
			Len ->
			    {MsgId,Command,Len,Payload};
			_Any ->
			    {error, message_corrupted}
		    end;
		_ ->
		    {error, cant_parse_list}
	    end

    end.

%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------

%%%===================================================================
%%% Internal functions
%%%===================================================================
