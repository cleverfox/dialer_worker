%%%-------------------------------------------------------------------
%%% @author Vladimir Goncharov <viruzzz@lnb.local>
%%% @copyright (C) 2012, Vladimir Goncharov
%%% @doc
%%%
%%% @end
%%% Created :  7 Aug 2012 by Vladimir Goncharov <viruzzz@lnb.local>
%%%-------------------------------------------------------------------
-module(mytest).

%% API
-export([login/0]).
-import(fbp,[packFBP/3]).
%%%===================================================================
%%% API
%%%===================================================================

logsend(S,Y) ->
    io:format("Sending ~p~n",[Y]),
    gen_tcp:send(S,Y).

sendFBP(Socket,MsgId,Command,Data) ->
    logsend(Socket,packFBP(MsgId,Command,Data)),
    receive 
	{tcp,_Sock,RData} ->
	    io:format("Received ~p~n",[RData]),
	    case fbp:parseFBP(RData) of
		{MsgId,Command,Len,Payload} ->
		    io:format("Received command ~p with ~p bytes of payload~n",[Command,Len]),
		    io:format("\tBERT Payload ~p~n",[bert:decode(Payload)]),
		    ok;
		{error, Errid} ->
		    io:format("Error: ~p~n",[Errid]),




		    error
	    end;
	M ->
	    io:format("Received ~p~n",[M]),
	    error
    after 100 ->
	    ok
    end.


testFBP(Socket) ->
    ok=sendFBP(Socket,10,16#0,[]),
    ok=sendFBP(Socket,11,16#1,"test"),
%    ok=sendFBP(Socket,11,16#21,[]),
    ok=sendFBP(Socket,11,16#22,[]),
    finished.

flushbuffer()->
    flushbuffer(0).
flushbuffer(C) ->
    receive 
	_X ->
	    flushbuffer(C+1)
    after 100 ->
	    {ok, C}
    end.

login() ->
    flushbuffer(),
    {ok,S} = gen_tcp:connect({127,0,0,1},7977,[{packet,2}]),
    io:format("Connect ~p~n",[S]),
    receive 
	M ->
	    io:format("Received ~p~n",[M])
    after 100 ->
	    nothing
    end,
    logsend(S,<<"CHAP-SHA1 vladimir@my.net">>),
    receive 
	{tcp, _Port, String} ->
	    io:format("Received ~p~n",[String]),
	    [_Method,Challenge]=string:tokens(String," "),
	    logsend(S,crypto:sha_mac("mypw",Challenge))
    after 100 ->
	    io:format("Timeout~n",[])
    end,
    receive 
	MM ->
	    io:format("Received ~p~n",[MM]),
	    receive 
		{tcp, _, "FirstBinaryProtocol"} ->
		    io:format("Switched to FirstBinaryProtocol~n",[]),
		    testFBP(S)
	    after 1000 ->
		    nothing
	    end
    after 1000 ->
	    nothing
    end,


						%{tcp,#Port<0.800>, "CHAP-SHA1 q{J+Y.=m1`{E>^-t0@?}^SFGnG=-BM@;"}
						%> gen_tcp:send(S,crypto:sha_mac("password","q{J+Y.=m1`{E>^-t0@?}^SFGnG=-BM@;")).
						%ok
						%> f(M), receive M -> M after 0 -> timeout end.                            
						%{tcp,#Port<0.800>,"OK Welcome, me@somedomain"}
    gen_tcp:close(S).


%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------

%%%===================================================================
%%% Internal functions
%%%===================================================================
