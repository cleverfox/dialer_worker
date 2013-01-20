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

-compile([{parse_transform, lager_transform}]).
%% API
-export([start_link/4,originate/5]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-define(SERVER, ?MODULE). 

-record(state, {socket,host,port,username,secret,state,buffer,job,cntr}).
-record(job, {jobid,uniqid,uid,from,ext,state,res,reason,echan,hup,huptxt,timeout,callnum,start}).

%%%===================================================================
%%% API
%%%===================================================================

originate(UID,Chan,Ext,Timeout,Args) -> 
    gen_server:call(?MODULE, {originate,UID,Chan,Ext,Timeout,Args}, 600000).

%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @spec start_link() -> {ok, Pid} | ignore | {error, Error}
%% @end
%%--------------------------------------------------------------------
start_link(Host,Port,Username,Secret) ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, 
        [Host,Port,Username,Secret], []).

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
        erlang:send_after(100, self(), {connect, 1}),
            {ok, #state{
                    socket=false,
                    host=Host,
                    port=Port,
                    username=Username,
                    secret=Secret,
                    state=connect,
                    buffer=undefined,
                    job=[],
                    cntr=0
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
rnd(Prob) ->
    [Rnd|_]=binary_to_list(crypto:rand_bytes(1)),
    Rnd/256 < Prob.
        
handle_call({originate,UID,Chan,Ext,Timeout,Args}, From, 
    #state{ job = Job, cntr=Cnt} = State) ->
    lager:info("Originate ~p ~p, F ~p, S ~p~n",[Chan,Ext,From,State]),
    Channel=case application:get_env(ami_call_channel) of
        {ok, Xval1} ->
            io_lib:format(Xval1,[Chan,Ext])
    end,
    Tpl=case application:get_env(ami_template) of
        {ok, Xval2} ->
            Xval2
    end,
    %Ar1=[
    %    {"Channel",Channel},
    %    {"ActionID",Chan},
    %    {"Account",Chan}
    %],
    %Request=[Ar1 | Tpl],
    Fx=fun({A,B})-> 
            R=case is_atom(B) of 
                true ->
                    case B of
                        channel -> Channel; 
                        chan -> Chan; 
                        _ -> 
                            case lists:keyfind(B,1,Args) of
                                {B, Val} -> Val;
                                _ -> 
                                    lager:error("Value for atom ~p in call template is undefined",[B]),
                                    atom_to_list(B)
                            end
                    end;
                false -> B 
            end, 
            {A,R} 
    end,
    Request=lists:map(Fx,Tpl),
    case State#state.socket of
        false ->
            {reply, {error, ami_not_connected}, State};
        emulator ->
            lager:info("Emulator request: ~p",[Request]),
            {Prob_Ans,Prob_Busy,Prob_NA}=case application:get_env(ami_emulator) of
                {ok, {Pa,Pb,Pn}} -> 
                    {Pa, Pb, Pn};
                _ ->
                    {0.5, 0.5, 0.5}
            end,
            Reply=case rnd(Prob_Ans) of
                true ->
                    timer:sleep(5000),
                    {ok,{UID,Chan,Ext,hup,"Success","4",5}};
                false ->
                    case rnd(Prob_Busy) of
                        true ->
                            timer:sleep(2000),
                            {ok,{UID,Chan,Ext,res,"Failure","5",0}};
                        false ->
                            case rnd(Prob_NA) of
                                true ->
                                    timer:sleep(7000),
                                    {ok,{UID,Chan,Ext,res,"Failure","3",0}};
                                false ->
                                    timer:sleep(1000),
                                    {ok,{UID,Chan,Ext,res,"Failure","8",0}}
                            end
                    end
            end,
            lager:info("Emulator res: ~p",[Reply]),
            {reply, Reply, State};
        _ ->
            sendData(State,Request),
            %sendData(State,[
            %        {"Action","Originate"},
            %        %{"Channel","SIP/g102/"++Chan++Ext},
            %        {"Channel","IAX2/xhome/"++Ext},
            %        {"Context", "advert"},
            %        {"Exten","1"},
            %        {"Priority","1"},
            %        {"Callerid","123000"},
            %        {"Timeout","20000"},
            %        {"ActionID",Chan},
            %        {"Account",Chan},
            %        {"Async","1"}
            %    ]),
            Job1=lists:append(Job,[#job{uid=UID,jobid=Chan,from=From,ext=Ext,state=init,callnum=Cnt}]),
            erlang:send_after(Timeout, self(), {handletimeout, Cnt}),
            {noreply, State#state{job=Job1,cntr=Cnt+1}, 1200000}
    end;

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

handle_info({tcp_error, _Socket, _}, State) ->
      erlang:send_after(1000, self(), {connect, 1}),
      gen_tcp:close(State#state.socket),
      {noreply,State#state{buffer=undefined,state=connect,socket=false}};

handle_info({tcp_closed, _Socket}, State) ->
      erlang:send_after(1000, self(), {connect, 1}),
      {noreply,State#state{buffer=undefined,state=connect,socket=false}};

handle_info({tcp, Socket, Data}, #state{ state=CS, buffer=Buf } = State) ->
    inet:setopts(Socket, [{active, once}]),
    case CS of
        connect -> 
            lager:info("Connected with ~p~n",[Data]),
            Username=case State#state.username of
                env ->
                    {ok,Xval1}=application:get_env(ami_username),
                    Xval1;
                _ -> 
                    State#state.username
            end,
            Secret=case State#state.secret of
                env ->
                    {ok,Xval2}=application:get_env(ami_secret),
                    Xval2;
                _ -> 
                    State#state.secret
            end,


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
                    S2=handle_data(State,Buf),
                    lager:info("~p~n~n",[S2#state.job]),
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

handle_info({handletimeout, CallId},State) ->
    JSta=lists:keyfind(CallId,#job.callnum,State#state.job),
    case JSta of
        false ->
            lager:info("Timeout on dead call ~p~n",[CallId]),
            {noreply, State};
       _  ->
            NSta=JSta#job{state=timeout},
            lager:info("Timeout on call ~p ~p~n",[CallId,JSta]),
            make_reply(none,NSta),
            sendData(State,[
                    {"Action","Hangup"},
                    {"Channel", JSta#job.echan}
                ]),

            J=lists:delete(undef,lists:map(fun(X) -> 
                            case X#job.callnum == CallId of 
                                true -> undef;
                                _ -> X
                            end
                    end, State#state.job)),
            {noreply, State#state{job=J}}
    end;


handle_info({connect, Times},State) ->
    Host=case State#state.host of
        env ->
            {ok,XHost}=application:get_env(ami_host),
            XHost;
        _ -> 
            State#state.host
    end,
    Port=case State#state.port of
        env ->
            {ok,XPort}=application:get_env(ami_port),
            XPort;
        _ -> 
            State#state.port
    end,

    case Host of 
        emulator -> 
            {noreply, State#state{socket=emulator}};
        _ ->
            case gen_tcp:connect(Host, Port, [list, inet, {active, once}, 
                        {exit_on_close, true}, {nodelay, true},
                        {packet, line}, {recbuf, 524288}]) of 
                {ok, Sock} -> 
                    {noreply, State#state{socket=Sock}};
                {error, _} ->
                    erlang:send_after(1000, self(), {connect, Times+1}),
                    {noreply, State}
            end
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

join_req(List) ->
    lists:flatten([lists:map(fun({X,Y}) -> [X,": ",Y,"\r\n"] end,List)|"\r\n"]).

sendData(#state{socket=Sock}=_State,Array) ->
    lager:info("Send(~p)~n",[Array]),
    Req=join_req(Array),
    ok = gen_tcp:send(Sock, Req).

make_reply(Res,JSta) ->
    Reply=case Res of 
        none ->
            {JSta#job.uid,JSta#job.jobid,JSta#job.ext,JSta#job.state,JSta#job.res,JSta#job.reason,
                undef};
        duration ->
            {JSta#job.uid,JSta#job.jobid,JSta#job.ext,JSta#job.state,JSta#job.res,JSta#job.reason,
                calendar:datetime_to_gregorian_seconds({date(),time()})-JSta#job.start}
    end,    
    gen_server:reply(JSta#job.from,{ok,Reply}).

handle_data(State,[Action|Array]) ->
    %io:format("Recvd(~p)~n",[Array]),
    %case [Array] of 
    %    [{_,"Authentication accepted"}] ->
    %        io:format("AMI ready~n");
    %     _ -> 
    lager:info("Received state ~p message ~p ~n",[State#state.state,Action]),
    lager:info("Data  ~p ~n",[Array]),
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
                    case lists:keyfind("ActionID",1,Array) of
                        {"ActionID",ID} ->
                            JSta=lists:keyfind(ID,#job.jobid,State#state.job),
                            JSta#job{state=queue};
                        _ ->
                            undefined
                    end;
                %{"Response","Fail"} ->
                %    undefined;
                {"Event","OriginateResponse"} ->
                    {"ActionID",ID}=lists:keyfind("ActionID",1,Array),
                    JSta=lists:keyfind(ID,#job.jobid,State#state.job),
%                    io:format("List ~p~n Found ~p~n",[State#state.job,JSta]),
                    case JSta of
                        false ->
                            undefined;
                        _ ->
                            {"Response",Resp}=lists:keyfind("Response",1,Array),
                            {"Reason",Reas}=lists:keyfind("Reason",1,Array),
                            case Resp of
                                "Failure" ->
                                    NSta=JSta#job{state=res,res=Resp,reason=Reas},
                                    make_reply(none,NSta),
                                    %gen_server:reply(JSta#job.from,{ok,JSta#job{state=fail,res=Resp,reason=Reas}}),
                                    %JSta#job{state=res,res=Resp,reason=Reas};
                                    {finish, ID};
                                "Success" ->
                                    JSta#job{state=progress,res=Resp,reason=Reas,start=calendar:datetime_to_gregorian_seconds({date(),time()})}
                            end
                    end;
                {"Event","Hangup"} ->
                    {"Uniqueid",UID}=lists:keyfind("Uniqueid",1,Array),
                    JSta=lists:keyfind(UID,#job.uniqid,State#state.job),
                    case JSta of
                        false ->
                            undefined;
                        X ->
                            case JSta#job.state of
                                progress ->
                                    {_,Hup}=lists:keyfind("Cause",1,Array), 
                                    {_,HupTxt}=lists:keyfind("Cause-txt",1,Array), 
                                    NSta=X#job{state=hup,hup=Hup,huptxt=HupTxt},
                                    make_reply(duration,NSta),
                                    {finish, NSta#job.jobid};
                                _ ->
                                    {_,Hup}=lists:keyfind("Cause",1,Array), 
                                    {_,HupTxt}=lists:keyfind("Cause-txt",1,Array), 
                                    X#job{hup=Hup,huptxt=HupTxt}
                            end
                    end;
                {"Event","NewAccountCode"} -> 
                    {"AccountCode",ID}=lists:keyfind("AccountCode",1,Array),
                    JSta=lists:keyfind(ID,#job.jobid,State#state.job),
                    {"Channel",EC}=lists:keyfind("Channel",1,Array),
                    {"Uniqueid",UID}=lists:keyfind("Uniqueid",1,Array),
                    JSta#job{state=queue,uniqid=UID,echan=EC};
                _ -> 
                    lager:info("Unknown message ~p (~p)~n",[Action,Array]),
                    undefined
            end,
            case M of 
                undefined -> 
                    State;
                {finish, JID} ->
                    J=lists:delete(undef,lists:map(fun(X) -> 
                                case X#job.jobid == JID of 
                                    true -> undef;
                                    _ -> X
                                end
                        end, State#state.job)),
                    State#state{job=J};
                _ -> 
                    J=lists:map(fun(X) -> 
                                case X#job.jobid == M#job.jobid of 
                                    true -> M;
                                    _ -> X
                                end
                        end, State#state.job),
                    State#state{job=J}
            end
    end.

