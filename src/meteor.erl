%%%-------------------------------------------------------------------
%%% @author Vladimir Goncharov <viruzzz@lnb.local>
%%% @copyright (C) 2012, Vladimir Goncharov
%%% @doc
%%%
%%% @end
%%% Created :  7 Aug 2012 by Vladimir Goncharov <viruzzz@lnb.local>
%%%-------------------------------------------------------------------
-module(meteor).
-behaviour(gen_server).

-compile([{parse_transform, lager_transform}]).
%% API
-export([start_link/2,message/2,json/2,serialize/1]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-define(SERVER, ?MODULE). 

-record(state, {socket,host,port}).

%%%===================================================================
%%% API
%%%===================================================================

message(Chan,Data) -> 
    %lager:info("Chan ~p ~p",[Chan,Data]),
    gen_server:cast(?MODULE, {message,Chan,Data}).

serialize([]) ->
    [];

serialize({Name, [{A,B}|M]}) ->
    [34,Name,34,": {",serialize([{A,B}|M]),"}"];

serialize({Name, Data}) ->
    case is_integer(Data) of
        true ->
            [34,Name,34,": ",integer_to_list(Data)];
        false ->
            case Data of
                null ->
                    [34,Name,34,": null "];
                _ ->
		    F = fun(X) -> case X of 34 -> "\\\\" ++ [X]; _ -> X end end,
		    Data1=lists:flatten([ F(X) || X <- Data ]),
                    [34,Name,34,": ",34,Data1,34]
            end
end;

serialize([{Name, Data}]) ->
    serialize({Name, Data});

serialize([{Name, Data}|X]) ->
    M=serialize(X),
    [serialize({Name, Data}),", "|M].
    
json(Chan,Data) -> 
    lager:info("Data to send ~p",[Data]),
    Json=lists:flatten(["{",serialize(Data),"}"]),
    message(Chan,Json),
    ok.

%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @spec start_link() -> {ok, Pid} | ignore | {error, Error}
%% @end
%%--------------------------------------------------------------------
start_link(Host,Port) ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [Host,Port], []).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Initializes the server
%%
%% @spec init(Args) -> {ok, State} |
%%                     {ok, State, Timeout} |
%%                     ignore |
%%                     {stop, Reason}
%% @end
%%--------------------------------------------------------------------
init([Host, Port]) ->
        erlang:send_after(100, self(), {connect, 1}),
            {ok, #state{
                    socket=false,
                    host=Host,
                    port=Port
                }}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling call messages
%%
%% @spec handle_call(Request, From, State) ->
%%                                   {reply, Reply, State} |
%%                                   {reply, Reply, State, Timeout} |
%%                                   {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, Reply, State} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
       
handle_call(_Request, _From, State) ->
    Reply = unknown_request,
    {reply, Reply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling cast messages
%%
%% @spec handle_cast(Msg, State) -> {noreply, State} |
%%                                  {noreply, State, Timeout} |
%%                                  {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------

handle_cast({message,Chan,Msg}, State) ->
    case State#state.socket of
        false ->
            {noreply, State};
        _ ->
            Data=io_lib:format("ADDMESSAGE ~s ~s~c~n",[Chan, Msg, 13]),
            %lager:info("Send to meteor ~p",[Data]),
            ok = gen_tcp:send(State#state.socket, Data),
            {noreply, State}
    end;

handle_cast(_Msg, State) ->
        {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling all non call/cast messages
%%
%% @spec handle_info(Info, State) -> {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------

handle_info({tcp_error, _Socket, _}, State) ->
      erlang:send_after(1000, self(), {connect, 1}),
      gen_tcp:close(State#state.socket),
      {noreply,State#state{socket=false}};

handle_info({tcp_closed, _Socket}, State) ->
      erlang:send_after(1000, self(), {connect, 1}),
      {noreply,State#state{socket=false}};

handle_info({tcp, Socket, _Data}, State) ->
    inet:setopts(Socket, [{active, once}]),
    %lager:info("Meteor data ~p",[Data]),
    {noreply, State};

handle_info({connect, Times},State) ->
    lager:info("Connect ~p time",[Times]),
    Host=case State#state.host of
        env ->
            {ok,XHost}=application:get_env(meteor_host),
            XHost;
        _ -> 
            State#state.host
    end,
    Port=case State#state.port of
        env ->
            {ok,XPort}=application:get_env(meteor_port),
            XPort;
        _ -> 
            State#state.port
    end,

    case gen_tcp:connect(Host, Port, [list, inet, {active, once}, 
                {exit_on_close, true}, {nodelay, true},
                {packet, line}, {recbuf, 524288}]) of 
        {ok, Sock} -> 
            {noreply, State#state{socket=Sock}};
        {error, _} ->
            erlang:send_after(1000, self(), {connect, Times+1}),
            {noreply, State}
    end;



handle_info(_Info, State) ->
    {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any
%% necessary cleaning up. When it returns, the gen_server terminates
%% with Reason. The return value is ignored.
%%
%% @spec terminate(Reason, State) -> void()
%% @end
%%--------------------------------------------------------------------
terminate(_Reason, _State) ->
    ok.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Convert process state when code is changed
%%
%% @spec code_change(OldVsn, State, Extra) -> {ok, NewState}
%% @end
%%--------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

%% Private

