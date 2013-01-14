%%%-------------------------------------------------------------------
%%% @author Vladimir Goncharov <viruzzz@lnb.local>
%%% @copyright (C) 2012, Vladimir Goncharov
%%% @doc
%%%
%%% @end
%%% Created :  7 Aug 2012 by Vladimir Goncharov <viruzzz@lnb.local>
%%%-------------------------------------------------------------------
-module(tcp_fp).

-behaviour(gen_fsm).

-export([start_link/0, set_socket/2]).

%% gen_fsm callbacks
-export([init/1, handle_event/3,
         handle_sync_event/4, handle_info/3, 
	 terminate/3, code_change/4]).

%% FSM States
-export([
	 stateNew/2,
	 stateUsername/2,
	 stateAuth/2,
	 stateFBP/2
	]).


-record(state, {
	  socket,    % client socket
	  addr,      % client address
	  port,      % client port
 	  username,  % username
	  challenge, % auth challenge
	  domain     % user domain
	 }).

-define(TIMEOUT, 120000).

%%%------------------------------------------------------------------------
%%% API
%%%------------------------------------------------------------------------

%%-------------------------------------------------------------------------
%% @spec (Socket) -> {ok,Pid} | ignore | {error,Error}
%% @doc To be called by the supervisor in order to start the server.
%%      If init/1 fails with Reason, the function returns {error,Reason}.
%%      If init/1 returns {stop,Reason} or ignore, the process is
%%      terminated and the function returns {error,Reason} or ignore,
%%      respectively.
%% @end
%%-------------------------------------------------------------------------
start_link() ->
    gen_fsm:start_link(?MODULE, [], []).

set_socket(Pid, Socket) when is_pid(Pid), is_port(Socket) ->
    gen_fsm:send_event(Pid, {socket_ready, Socket}).

%%%------------------------------------------------------------------------
%%% Callback functions from gen_server
%%%------------------------------------------------------------------------

%%-------------------------------------------------------------------------
%% Func: init/1
%% Returns: {ok, StateName, StateData}          |
%%          {ok, StateName, StateData, Timeout} |
%%          ignore                              |
%%          {stop, StopReason}
%% @private
%%-------------------------------------------------------------------------
init([]) ->
    process_flag(trap_exit, true),
    {ok, stateNew, #state{}}.

%%-------------------------------------------------------------------------
%% Func: StateName/2
%% Returns: {next_state, NextStateName, NextStateData}          |
%%          {next_state, NextStateName, NextStateData, Timeout} |
%%          {stop, Reason, NewStateData}
%% @private
%%-------------------------------------------------------------------------
stateNew ({socket_ready, Socket}, State) when is_port(Socket) ->
    inet:setopts(Socket, [{active, once}, {packet, 2}, binary]),
    {ok, {IP, Port}} = inet:peername(Socket),
    error_logger:info_msg("Accepted new FP socket from ~p:~p\n",[inet_parse:ntoa(IP),Port]),

    gen_tcp:send(Socket, list_to_binary(["CloudFS FirstProto ",
					 case inet:gethostname() of
					     {ok, Hostname} -> Hostname;
					     true -> "Unknown" 
					 end
					 ," version ","0.1","\r\n",
					 "AUTH: ",["CHAP-SHA1"]
					])),
    {next_state, stateUsername, State#state{socket=Socket, addr=IP, port=Port}, ?TIMEOUT};

stateNew (Other, State) ->
    error_logger:error_msg("State: ~p. Unexpected message: ~p\n", ["stateNew",Other]),
    {next_state, stateNew, State}.

stateUsername({data, Data}, #state{socket=S} = State) ->
    {Method,U,D}=
	try
	    [XMethod,XUser]=string:tokens(binary_to_list(Data)," "),
	    [XU,XD]=string:tokens(XUser,"@"),
	    {XMethod,XU,XD}
	catch
	    _:_ ->
		throw(protocol_mismatch)
	end,
    case Method of
	"CHAP-SHA1" ->
	    Chal=random_string(32),
	    ok = gen_tcp:send(S, list_to_binary(["CHAP-SHA1 ",Chal])),
	    {next_state, stateAuth, State#state{
				      challenge=Chal,
				      username=U,
				      domain=D
				     },?TIMEOUT};
	_ ->
	    ok = gen_tcp:send(S, list_to_binary(["DENY Unsupported Authentication method"])),
	    {stop, normal, State}
    end.

stateAuth({data, Data}, #state{addr=IP,port=Port,socket=S,username=U,domain=D,challenge=C} = State) ->
    case auth_server:authenticate({chapsha1,U,D,C,Data}) of
	allow -> 
	    ok = gen_tcp:send(S, list_to_binary(["OK Welcome, ",U,"@",D])),
	    ok = gen_tcp:send(S, list_to_binary(["FirstBinaryProtocol"])),
    error_logger:info_msg("Client ~p:~p authencticated as ~p@~p\n",[inet_parse:ntoa(IP),Port,U,D]),
	    {next_state, stateFBP, State, ?TIMEOUT};
	deny ->
	    ok = gen_tcp:send(S, list_to_binary(["DENY Login incorrect"])),
	    {stop, normal, State};
	error ->
	    ok = gen_tcp:send(S, list_to_binary(["ERROR Try again later"])),
	    {stop, normal, State}
    end.

stateFBP ({data, Data}, #state{username=U,socket=S} = State) ->
    case fbp:parseFBP(Data) of
	{MsgId,Command,_Len,Payload} ->
	    io:format("Client ~p: Request ~p [~p]~n",[U,Command,Payload]),
	    R=client_handler:handle_command(Command,Payload,MsgId,State),
	    io:format("Client ~p: Response ~p~n",[U,R]),
	    case R of
		{ok, _RespTerm} ->
		    ok = gen_tcp:send(S, fbp:packFBP(MsgId,Command,bert:encode(R)));
		{warn,Reason} ->
		    error_logger:warning_msg("Client ~p command ~p Warning: ~p~n",[U,Command,Reason]);
		{error,Reason} ->
		    error_logger:warning_msg("Client ~p command ~p Error: ~p~n",[U,Command,Reason]),
		    ok = gen_tcp:send(S, fbp:packFBP(MsgId,Command,bert:encode(R)));
		{ok} ->
		    donothing
	    end;
	{error, Errid} ->
	    error_logger:warning_msg("Client ~p: error: ~p~n",[U,Errid])
    end,
    {next_state, stateFBP, State, ?TIMEOUT};

stateFBP (timeout, #state{addr=A} = State) ->
    error_logger:warning_msg("~p Client ~p connection timeout - closing.\n", [self(),A]),
    {stop, normal, State};

stateFBP (Data, State) ->
    error_logger:error_msg("~p Ignoring data: ~p\n", [self(), Data]),
    {next_state, stateFBP, State, ?TIMEOUT}.

%%-------------------------------------------------------------------------
%% Func: handle_event/3
%% Returns: {next_state, NextStateName, NextStateData}          |
%%          {next_state, NextStateName, NextStateData, Timeout} |
%%          {stop, Reason, NewStateData}
%% @private
%%-------------------------------------------------------------------------
handle_event(Event, StateName, StateData) ->
    {stop, {StateName, undefined_event, Event}, StateData}.

%%-------------------------------------------------------------------------
%% Func: handle_sync_event/4
%% Returns: {next_state, NextStateName, NextStateData}            |
%%          {next_state, NextStateName, NextStateData, Timeout}   |
%%          {reply, Reply, NextStateName, NextStateData}          |
%%          {reply, Reply, NextStateName, NextStateData, Timeout} |
%%          {stop, Reason, NewStateData}                          |
%%          {stop, Reason, Reply, NewStateData}
%% @private
%%-------------------------------------------------------------------------
handle_sync_event(Event, _From, StateName, StateData) ->
    {stop, {StateName, undefined_event, Event}, StateData}.

%%-------------------------------------------------------------------------
%% Func: handle_info/3
%% Returns: {next_state, NextStateName, NextStateData}          |
%%          {next_state, NextStateName, NextStateData, Timeout} |
%%          {stop, Reason, NewStateData}
%% @private
%%-------------------------------------------------------------------------
handle_info({tcp, Socket, Bin}, StateName, #state{socket=Socket} = StateData) ->
						% Flow control: enable forwarding of next TCP message
    inet:setopts(Socket, [{active, once}]),
    ?MODULE:StateName({data, Bin}, StateData);

handle_info({tcp_closed, Socket}, _StateName,
            #state{socket=Socket, addr=Addr, port=Port} = StateData) ->
    error_logger:info_msg("Client ~p:~p disconnected.\n", [inet_parse:ntoa(Addr),Port]),
    {stop, normal, StateData};

handle_info(_Info, StateName, StateData) ->
    {noreply, StateName, StateData}.

%%-------------------------------------------------------------------------
%% Func: terminate/3
%% Purpose: Shutdown the fsm
%% Returns: any
%% @private
%%-------------------------------------------------------------------------
terminate(_Reason, _StateName, #state{socket=Socket}) ->
    (catch gen_tcp:close(Socket)),
    ok.

%%-------------------------------------------------------------------------
%% Func: code_change/4
%% Purpose: Convert process state when code is changed
%% Returns: {ok, NewState, NewStateData}
%% @private
%%-------------------------------------------------------------------------
code_change(_OldVsn, StateName, StateData, _Extra) ->
    {ok, StateName, StateData}.

random_string(N) -> 
    random_seed(), 
    random_string(N, []).

random_string(0, D) -> 
    D; 
random_string(N, D) ->
    random_string(N-1, [random:uniform(93)+33|D]).

random_seed() -> 
    {_,_,X} = erlang:now(), 
    {H,M,S} = time(), 
    H1 = H * X rem 32767, 
    M1 = M * X rem 32767, 
    S1 = S * X rem 32767, 
    put(random_seed, {H1,M1,S1}).
