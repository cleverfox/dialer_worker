%%%-------------------------------------------------------------------
%%% @author Vladimir Goncharov <viruzzz@lnb.local>
%%% @copyright (C) 2012, Vladimir Goncharov
%%% @doc
%%%
%%% @end
%%% Created :  7 Aug 2012 by Vladimir Goncharov <viruzzz@lnb.local>
%%%-------------------------------------------------------------------
-module(ami_server).
-behaviour(gen_server).

%% API
-export([start_link/1]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
	 terminate/2, code_change/3]).

-export([authenticate/1,ping/1]).
-export([squery/1]).
-export([splitandtrim/4,splitandtrim/1,strunc/1]).

-define(SERVER, ?MODULE). 

-record(state, {socket,username,secret,state,buffer,job}).
-record(job, {chan,from,ext,state,uniqid,res,reason}).

%%%===================================================================
%%% API
%%%===================================================================

authenticate({Method, Username, Domain, Challenge, Hash}) -> 
    gen_server:call(?MODULE, {auth, Method, Username, Domain, Challenge, Hash}).

ping(Data) -> 
    gen_server:call(?MODULE, {myping, Data}).

%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @spec start_link() -> {ok, Pid} | ignore | {error, Error}
%% @end
%%--------------------------------------------------------------------
start_link(Params) ->
        gen_server:start_link({local, ?SERVER}, ?MODULE, Params, []).

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
init([Host, Port, Username, Secret]) ->
    case gen_tcp:connect(Host, Port, [list, inet, {active, once}, 
                        {exit_on_close, true}, {nodelay, true},
                        {packet, line}, {recbuf, 524288}]) of 
                        {ok, Sock} -> 
                                {ok, #state{
                                        socket=Sock,
                                        username=Username,
                                        secret=Secret,
                                        state=connect,
                                        buffer=undefined,
                                        job=[]
                                    }};
                        Any ->
                            Any
                end.

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
handle_call({originate,Chan,Ext}, From, #state{ job = Job } = State) ->
        io:format("Originate ~p ~p, F ~p, S
            ~p~n",[Chan,Ext,From,State]),
            sendData(State,[
                   {"Action","Originate"},
                   {"Channel","SIP/g101/"++Chan++Ext},
                   {"Context", "advert"},
                   {"Exten","1"},
                   {"Priority","1"},
                   {"Callerid","123000"},
                   {"ActionID",Chan},
                   {"Account",Chan},
                   {"Async","1"}
               ]),
           Job1=lists:append(Job,[#job{chan=Chan,from=From,ext=Ext,state=init}]),
            {noreply, State#state{job=Job1},60000};

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
handle_info({tcp, Socket, Data},
    #state{
        username=Username,
        secret=Secret,
        state=CS,
        buffer=Buf
    } = State) ->
     inet:setopts(Socket, [{active, once}]),
    case CS of
        connect -> 
            io:format("Connected with ~p~n",[Data]),
            sendData(State,[
                   {"Action","Login"},
                   {"Username",Username},
                   {"Secret", Secret}
               ]),
            {noreply, State#state{state=auth}};
        _ -> 
            %io:format("Recvd ~p~n",[Data]),
            NS=case Data of 
                "\r\n" -> 
                    S2=flush(State,Buf),
                    %io:format("State update ~p~n",[S2]),
                    S2#state{buffer=undefined};
                Any ->
                    {ok, C1, C2} = splitandtrim(Any),
                    L=case Buf of 
                        [_|_] ->
                            lists:append(Buf,[{C1,C2}]);
                         undefined ->
                             [{C1,C2}]
                    end,
                    State#state{buffer=L}
            end,
            %io:format("Buf ~p~n",[L]),
            {noreply, NS}
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
strunc("") -> "";
strunc([C|Input]) ->
    R=strunc(Input),
    case {C,R} of
        {32,[]} -> R;
        {32,[_|_]} -> [C|R];
        _ -> [C|R]
    end.

splitandtrim([],C1,C2,_W) ->
    {ok,strunc(C1),strunc(C2)};
splitandtrim([C|Input],C1,C2,W) ->
    case {C,W} of 
        {58, 1} -> splitandtrim(Input,C1,C2,2);
        {58, 2} -> {error, seconday_colon};
        {10, 2} -> splitandtrim([],C1,C2,2);
        {13, 2} -> splitandtrim([],C1,C2,2);
        {32, 1} -> case length(C1) of 
                0 -> splitandtrim(Input,C1,C2,1);
                _ -> splitandtrim(Input,lists:append(C1,[C]),C2,W)
            end;
        {32, 2} -> case length(C2) of 
                0 -> splitandtrim(Input,C1,C2,2);
                _ -> splitandtrim(Input,C1,lists:append(C2,[C]),W)
            end;
        {_, 1} -> splitandtrim(Input,lists:append(C1,[C]),C2,W);
        {_, 2} -> splitandtrim(Input,C1,lists:append(C2,[C]),W)
    end.

splitandtrim(X) ->
    splitandtrim(X,"","",1).

%trim_whitespace(Input) ->
%    splitandtrim(Input,"","",1).
    %lists:delete(13,lists:delete(10,Input)).

%re:replace(Input, "(\r\n)*", "").
join_req(List) ->
    lists:flatten([lists:map(fun({X,Y}) -> [X,": ",Y,"\r\n"] end,List)|"\r\n"]).

sendData(#state{socket=Sock}=_State,Array) ->
    io:format("Send(~p)~n",[Array]),
    Req=join_req(Array),
    ok = gen_tcp:send(Sock, Req).

flush(State,[Action|Array]) ->
    %io:format("Recvd(~p)~n",[Array]),
    %case [Array] of 
    %    [{_,"Authentication accepted"}] ->
    %        io:format("AMI ready~n");
    %     _ -> 
    io:format("Received state ~p message ~p ~n    ~p~n",[State#state.state,Action,Array]),
    case State#state.state of
        auth ->
            case Action of
                {"Response","Success"} ->
                    State#state{state=working};
                _ ->
                    State 
            end;
        _ ->
            M=case Action of
                {"Response","Success"} ->
                    {"ActionID",ID}=lists:keyfind("ActionID",1,Array),
                    JSta=lists:keyfind(ID,2,State#state.job),
                    JSta#job{state=queue};
                %{"Response","Fail"} ->
                %    undefined;
                {"Event","OriginateResponse"} ->
                    {"ActionID",ID}=lists:keyfind("ActionID",1,Array),
                    JSta=lists:keyfind(ID,2,State#state.job),
                    {"Response",Resp}=lists:keyfind("Response",1,Array),
                    {"Reason",Reas}=lists:keyfind("Reason",1,Array),
                    case Resp of
                        "Failure" ->
                            gen_server:reply(JSta#job.from,{ok,JSta#job{state=res,res=Resp,reason=Reas}})
                    end,
                    JSta#job{state=res,res=Resp,reason=Reas};
                %{"Event","Hangup"} ->
                %    undefined;
                {"Event","NewAccountCode"} -> 
                    {"AccountCode",ID}=lists:keyfind("AccountCode",1,Array),
                    JSta=lists:keyfind(ID,2,State#state.job),
                    {"Uniqueid",UID}=lists:keyfind("Uniqueid",1,Array),
                    JSta#job{state=queue,uniqid=UID};
                _ -> 
                    io:format("Unknown message ~p (~p)~n",[Action,Array]),
                    undefined
            end,
            case M of 
                undefined -> 
                    State;
                _ -> 
                    J=lists:map(fun(X) -> 
                                case X#job.chan == M#job.chan of 
                                    true -> M;
                                    _ -> X
                                end
                            end, State#state.job),
                    State#state{job=J}
            end
    end.


squery(Sql) ->
    poolboy:transaction(auth_db_worker, fun(Worker) ->
        gen_server:call(Worker, {squery, Sql})
    end).

getpwuser(Username, Domain) ->
    {ok, _, Res} = squery(lists:flatten(["select uid from domains where name='", Domain , "';"])),
    case Res of
	[] ->
	    {error, unknown_realm};
	[{DID}] ->
	    Query=lists:flatten(["select uid, password from users where username='", Username, "' and domain_id=", binary_to_list(DID), ";"]),
%%	    io:format("Query: ~p~n",[Query]),
	    {ok, _, User} = squery(Query),
	    case User of 
		[] ->
		    {error, no_such_user};
		[{Uid,Upw}] ->
		    {ok, {Uid, Upw}}
	    end
    end.
