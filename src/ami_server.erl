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
-export([start_link/4,originate/5,status/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-define(SERVER, ?MODULE). 

-record(state, {socket,host,port,username,secret,state,buffer,job,cntr}).
-record(job,
    {modemid,uniqid,uid,from,ext,state,res,reason,echan,hup,huptxt,timeout,callnum,start,ivrres}).

%%%===================================================================
%%% API
%%%===================================================================

originate(UID,MID,Ext,Timeout,Args) -> 
    gen_server:cast(?MODULE,
        {self(),{originate,UID,MID,Ext,Timeout,Args}}),
    {ok, 0}.

status() -> 
    gen_server:call(?MODULE, {status}, 600).

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
%%% GEN_Server callbacks
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

handle_call({status}, _From, State) ->
    ModemSt=[ {X#job.modemid, X#job.ext, X#job.state} || X <- State#state.job ],
    lager:notice("Cast Status: ~p",[ModemSt]),
    {reply,ModemSt,State};


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
rnd(Prob) ->
    [Rnd|_]=binary_to_list(crypto:rand_bytes(1)),
    Rnd/256 < Prob.
        
handle_cast({From, {originate, UID, MID, Ext, Timeout, Args}}, #state{ job = Job, cntr=Cnt} = State) ->
    Channel=case lists:keyfind(channel,1,Args) of
        {channel, CustChan} ->
            lists:flatten(io_lib:format(CustChan,[Ext]));
        _ ->
            case application:get_env(ami_call_channel) of
                {ok, Xval1} ->
                    io_lib:format(Xval1,[MID,Ext])
            end
    end,
    Cdr=case lists:keyfind(cdrfile,1,Args) of
        {cdrfile, Filename} ->
            [{"Variable", lists:flatten("cdrfile="++Filename)}];
        _ ->
            []
    end,
    Tpl=case application:get_env(ami_template) of
        {ok, Xval2} ->
            Xval2++Cdr
    end,
    lager:info("Originate ~p ~p~n",[Channel,Args]),
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
                        chan -> MID; 
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
                    {ok,{UID,MID,Ext,hup,"Success","4",5}};
                false ->
                    case rnd(Prob_Busy) of
                        true ->
                            timer:sleep(2000),
                            {ok,{UID,MID,Ext,res,"Failure","5",0}};
                        false ->
                            case rnd(Prob_NA) of
                                true ->
                                    timer:sleep(7000),
                                    {ok,{UID,MID,Ext,res,"Failure","3",0}};
                                false ->
                                    timer:sleep(1000),
                                    {ok,{UID,MID,Ext,res,"Failure","8",0}}
                            end
                    end
            end,
            lager:info("Emulator res: ~p",[Reply]),
            {reply, Reply, State};
        _ ->
            sendData(State,Request),
            Job1=lists:append(Job,[#job{uid=UID,modemid=MID,from=From,ext=Ext,state=init,callnum=Cnt,ivrres=null}]),
            erlang:send_after(Timeout, self(), {handletimeout, Cnt}),
            {noreply, State#state{job=Job1,cntr=Cnt+1}}
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
                    %lager:info("~p~n~n",[S2#state.job]),
                    %lager:info("State update ~p",[S2]),
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

handle_info({hanguptimeout, UID},State) ->
    JSta=lists:keyfind(UID,#job.uniqid,State#state.job),
    lager:notice("Timeout Hangup uid: ~p ~p",[UID,JSta]),
    case JSta of
        false ->
            {noreply, State};
        X ->
            lager:notice("Timeout Hangup ~p ~p uid: ~p, sta: ~p",[JSta#job.uid,JSta#job.modemid,UID,JSta]),
            NJob=lists:filter(fun(A) -> A#job.modemid =/= JSta#job.modemid end, State#state.job),
            make_reply(none,X),
            lager:notice("reply for strange call timeout ~p",[lager:pr(X, ?MODULE)]),
            
            {noreply, State#state{job=NJob}}
    end;


%handle_info({showstate},State) ->
%    ModemSt=[ {X#job.modemid, X#job.ext} || X <- State#state.job ],
%    lager:notice("Status: ~p",[ModemSt]),
%    erlang:send_after(5000, self(), {showstate}),
%    {noreply,State};

handle_info({handletimeout, CallId},State) ->
    JSta=lists:keyfind(CallId,#job.callnum,State#state.job),
    case JSta of
        false ->
            lager:info("Timeout on dead call ~p~n",[CallId]),
            {noreply, State};
       _  ->
            NSta=JSta#job{state=timeout},
            lager:info("Timeout on call ~p ~p~n",[JSta#job.uid,JSta#job.modemid,CallId,JSta]),
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
    lists:flatten([lists:map(fun({X,Y}) -> [X,": ",
                            case Y of
                                I when is_integer(I) ->
                                    integer_to_list(I);
                                L when is_list(L) ->
                                    L;
                                B when is_binary(B) ->
                                    binary_to_list(B)
                            end
                                ,"\r\n"] end,List)|"\r\n"]).

sendData(#state{socket=Sock}=_State,Array) ->
    %lager:info("Send(~p)~n",[Array]),
    Req=join_req(Array),
    ok = gen_tcp:send(Sock, Req).

make_reply(Res,JSta) ->
    Reply=case Res of 
        none ->
            {JSta#job.uid,JSta#job.modemid,JSta#job.ext,JSta#job.state,JSta#job.res,JSta#job.reason,
                0,JSta#job.ivrres};
        duration ->
            {JSta#job.uid,JSta#job.modemid,JSta#job.ext,JSta#job.state,JSta#job.res,JSta#job.reason,
                calendar:datetime_to_gregorian_seconds({date(),time()})-JSta#job.start,JSta#job.ivrres}
    end,    
    lager:info("ami_Reply ~p",[Reply]),
    case Reply of
        %{_,_,_,res,"Failure","8",_} when ( Try > 0 ) ->
        %    [Rnd|_]=binary_to_list(crypto:rand_bytes(1)),
        %    timer:sleep(1000+erlang:round(Rnd/256*9000)),
        %    work(Jid,Arg,Pid,Try-1);
        {Jid,MID,Ext,Sta,Txt,Reason,Time,IvrRes} ->
            %{25,15,"+79102113571",res,"Failure","5",0,null}
            XJob=[ 
                {modemid,MID},
                {ext,Ext},
                {status,Sta},
                {res_txt,Txt},
                {res_num,Reason},
                {duration,Time},
                {ivrres,IvrRes}
            ],
            lager:info("Job ~p ~p finish ~p",[Jid,self(), {job_complete, Jid, XJob}]),
            JSta#job.from ! {job_complete, Jid, XJob};
        _ -> 
            Jid = JSta#job.uid,
        %    XJob=[ 
        %        {modemid,JSta#job.modemid},
        %        {ext,},
        %        {status,res},
        %        {res_txt,"Failure"},
        %        {res_num,"8"},
        %        {duration,0}
        %    ],
            XJob = [],
            lager:info("Job ~p ~p failfinish ~p",[Jid,self(), {job_error, Jid, XJob} ]),
            JSta#job.from ! {job_error, Jid, XJob }
    end.
%gen_server:reply(JSta#job.from,{ok,Reply}).

handle_data(State,[Action|Array]) ->
    %io:format("Recvd(~p)~n",[Array]),
    %case [Array] of 
    %    [{_,"Authentication accepted"}] ->
    %        io:format("AMI ready~n");
    %     _ -> 
    %lager:notice("Received message ~p ~n",[Action]),
    %lager:info("Data  ~p ~n",[Array]),
    case State#state.state of
        auth ->
            case Action of
                {"Response","Success"} ->
                    State#state{state=working};
                _ ->
                    State 
            end;
        _ ->
            lager:notice("Asterisk: ~p~n~p",[Action,Array]),
            M=case Action of
                {"Response","Success"} ->
                    case lists:keyfind("ActionID",1,Array) of
                        {"ActionID",ID} ->
                            JSta=lists:keyfind(list_to_integer(ID),#job.modemid,State#state.job),
                            case JSta of
                                false ->
                                    lager:info("WTF? ~p ~p",[Action, Array]), 
                                    lager:info("Job ~p",[State#state.job]), 
                                    lager:info("State ~p",[State]), 
                                    undef;
                                _ ->
                                    JSta#job{state=queue}
                            end;
                        _ ->
                            undefined
                    end;
                %{"Response","Fail"} ->
                %    undefined;
                {"Event","OriginateResponse"} ->
                    {"ActionID",ID}=lists:keyfind("ActionID",1,Array),
                    JSta=lists:keyfind(list_to_integer(ID),#job.modemid,State#state.job),
                    io:format("Found ~p~n in list ~p~n",[JSta,State#state.job]),
                    case JSta of
                        false ->
                            undefined;
                        _ ->
                            {"Response",Resp}=lists:keyfind("Response",1,Array),
                            {"Reason",Reas}=lists:keyfind("Reason",1,Array),
                            case Resp of
                                "Failure" ->
                                    NSta=JSta#job{state=res,res=Resp,reason=Reas},
                                    lager:notice("Finish failed job ~p ~p",[JSta#job.uid, JSta]),
                                    make_reply(none,NSta),
                                    %gen_server:reply(JSta#job.from,{ok,JSta#job{state=fail,res=Resp,reason=Reas}}),
                                    %JSta#job{state=res,res=Resp,reason=Reas};
                                    lager:notice("Finish job ~p on modem ~p ",[JSta#job.uid,JSta#job.modemid]),
                                    {finish, NSta#job.modemid};
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
                            lager:notice("Hangup: ~p ~p ~p",[JSta#job.uid,JSta#job.modemid,JSta]),
                            case JSta#job.state of
                                progress ->
                                    {_,Hup}=lists:keyfind("Cause",1,Array), 
                                    {_,HupTxt}=lists:keyfind("Cause-txt",1,Array), 
                                    lager:notice("Hangup progress call ~p ~p (~p ~p) with state ~p",[JSta#job.uid,JSta#job.modemid,Hup,HupTxt,JSta#job.state]),
                                    IvrRes=case lists:keyfind("CallerIDName",1,Array) of
                                        {"CallerIDName","IVRRES"} ->
                                            case lists:keyfind("CallerIDNum",1,Array) of
                                                {_, Val} -> Val;
                                                _ -> 
                                                    null
                                            end;
                                        _ ->
                                            null
                                    end, 
                                    NSta=X#job{state=hup,hup=Hup,huptxt=HupTxt,ivrres=IvrRes},
                                    make_reply(duration,NSta),
				    lager:notice("reply for normal ~p ~p call ~p",[JSta#job.uid,JSta#job.modemid,lager:pr(NSta, ?MODULE)]),
                                    {finish, NSta#job.modemid};
                                _ ->
                                    {_,Hup}=lists:keyfind("Cause",1,Array), 
                                    {_,HupTxt}=lists:keyfind("Cause-txt",1,Array), 
                                    NSta=X#job{state=hup,hup=Hup,huptxt=HupTxt,ivrres=null},
                                    lager:notice("Hangup call ~p ~p with no OriginateResponse (~p ~p) with state ~p ~p",[JSta#job.uid,JSta#job.modemid,Hup,HupTxt,JSta#job.state,JSta]),
                                    %case Hup of
                                    %    "17" -> 
                                    %        NSta=X#job{res="Failure",reason="5",state=hup,hup=Hup,huptxt=HupTxt,ivrres=null},
                                    %        make_reply(none,NSta),
                                    %        lager:notice("reply for strange call ~p",[lager:pr(NSta, ?MODULE)]),
                                    %        {finish, NSta#job.modemid};
                                    %    _ ->
                                    %        NSta=X#job{state=hup,hup=Hup,huptxt=HupTxt,ivrres=null},
                                    %        make_reply(none,NSta),
                                    %        lager:notice("reply for strange call ~p",[lager:pr(NSta, ?MODULE)]),
                                    %        {finish, NSta#job.modemid}
                                    %end
				    erlang:send_after(1000, self(), {hanguptimeout,UID}),
                                    NSta
                            end
                    end;
                {"Event","NewAccountCode"} -> 
                    case lists:keyfind("AccountCode",1,Array) of
                        false ->
                            undefined;
                        {"AccountCode",[]} ->
                            undefined;
                        {"AccountCode",ID} ->
                            JSta=lists:keyfind(list_to_integer(ID),#job.modemid,State#state.job),
                            case JSta of
                                false ->
                                    undefined;
                                _ -> 
                                    {"Channel",EC}=lists:keyfind("Channel",1,Array),
                                    {"Uniqueid",UID}=lists:keyfind("Uniqueid",1,Array),
                                    JSta#job{state=queue,uniqid=UID,echan=EC}
                            end
                    end;
                _ -> 
                    lager:notice("Unknown message ~p (~p)~n",[Action,Array]),
                    undefined
            end,
            case M of 
                undefined -> 
                    State;
                {finish, JID} ->
                    %                J=lists:delete(undef,lists:map(fun(X) -> 
                    %            case X#job.modemid== JID of 
                    %                true -> undef;
                    %                _ -> X
                    %            end
                    %    end, State#state.job)),
                    J=lists:filter(fun(X) -> X#job.modemid =/= JID end, State#state.job),

                    lager:notice("Finish job ~p~n ~p -> ~p",[JID,State#state.job,J]),
                    State#state{job=J};
                _ -> 
                    J=lists:map(fun(X) -> 
                                case X#job.modemid == M#job.modemid of 
                                    true -> M;
                                    _ -> X
                                end
                        end, State#state.job),
                    State#state{job=J}
            end
    end.

