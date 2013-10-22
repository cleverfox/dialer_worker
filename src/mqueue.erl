-module(mqueue).
-behaviour(gen_server).

-compile([{parse_transform, lager_transform}]).
%% API
-export([start_link/0,mergedb/2]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
	 terminate/2, code_change/3,calc_dstatus/2]).

-export([authenticate/1,ping/1]).
-export([squery/1,get_channel/4]).

-define(SERVER, ?MODULE). 

-record(state, {dict,lock}).
-record(job, {jid,nid,pid,data,tpl,chid,rec}).

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
start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

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
init([]) ->
    lager:info("~p started~n",[?MODULE]),
    erlang:send_after(5000, self(), queue_run),
    {ok, #state{dict=dict:new(),lock=dict:new()}}.

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
calc_dstatus([],Res) ->
    Res;

calc_dstatus([{Type,_}|Arr],Res) ->
    NRes=case lists:keyfind(Type,1,Res) of
        false ->
            Res++[{Type,1}];
        {TElm,VElm} ->
            lists:keyreplace(TElm,1,Res,{TElm,VElm+1})
    end,
    calc_dstatus(Arr,NRes).

handle_call({auth, chapsha1, Username, Domain, Challenge, Hash}, _From, State) ->
    case getpwuser(Username, Domain) of
	{ok, {_Uid, Pw}} ->
	    %%   io:format("Authenticating user ~p(~p) with pw ~p and challenge ~p~n",[Username,Uid,Pw,Challenge]),
	    case crypto:sha_mac(Pw,Challenge)=:=Hash of
		true -> 
		    lager:info("User ~p@~p: authentcation success~n",[Username,Domain]),
		    {reply, allow, State};
		false ->
		    lager:info("User ~p@~p: password incorrect~n",[Username,Domain]),
		    {reply, deny, State}
	    end;
	{error, Cause} ->
	     lager:error("User ~p@~p: auth error ~p~n",[Username,Domain,Cause]),
	    {reply, deny, Cause}
    end;

handle_call({status}, _From, State) ->
%    Dict=(State#state.dict),
%    Dict=[ dict:fetch(X,State#state.dict) || X <- dict:fetch_keys(State#state.dict)],
    Dict=[ dict:fetch(X,State#state.dict) || X <- lists:filter(fun(A) -> case A of {job,_} -> true; _ -> false end end,dict:fetch_keys(State#state.dict)) ],
    Dict1=[ { X#job.chid, X#job.jid, X#job.nid } || X <- Dict ],
    Lock=dict:fetch_keys(State#state.lock),
    {reply, {Lock, Dict1}, State};

handle_call({dstatus}, _From, State) ->
    R=calc_dstatus(dict:fetch_keys(State#state.dict),[]),
    {reply, R, State};

handle_call({rstatus}, _From, State) ->
    State#state.dict,
    lager:info("RawStatus: ~p",[ lager:pr(State,?MODULE) ]),
    {reply, State, State};

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

handle_cast({status}, State) ->
%    Dict=(State#state.dict),
%    Dict=[ dict:fetch(X,State#state.dict) || X <- dict:fetch_keys(State#state.dict)],
    Dict=[ dict:fetch(X,State#state.dict) || X <- lists:filter(fun(A) -> case A of {job,_} -> true; _ -> false end end,dict:fetch_keys(State#state.dict)) ],
    Dict1=[ { X#job.chid, X#job.jid, X#job.nid } || X <- Dict ],
    Lock=dict:fetch_keys(State#state.lock),
    lager:info("LStatus: ~p ",[ Lock ]),
    lager:info("DStatus: ~p ",[ Dict1 ]),
    {noreply, State};

handle_cast({dstatus}, State) ->
    R=calc_dstatus(dict:fetch_keys(State#state.dict),[]),
    lager:info("DStatus: ~p",[ R ]),
    {noreply, State};

handle_cast({rstatus}, State) ->
    State#state.dict,
    lager:info("RawStatus: ~p",[ lager:pr(State,?MODULE) ]),
    {noreply, State};

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

runJob (Jid,Arg) ->
    lager:info("Job ~p work ~p~n",[self(),[Jid,Arg]]),
    {ext,Ext}=lists:keyfind(ext,1,Arg),
    {modemid,MID}=lists:keyfind(modemid,1,Arg),
    Timeout=case lists:keyfind(timeout,1,Arg) of {timeout, To} -> To; _ -> 30000 end,
    CallRes=ami_server:originate(Jid,MID,Ext,Timeout,Arg),
    lager:info("Job ~p res ~p",[Jid,CallRes]),
    CallRes.

get_channel(Num,Dict,normal,Class) ->
    %Res=equery( 
    %    "SELECT m.id,prio,modem_id,interface from route r left join " ++ 
    %    "group_members m on m.group_id=r.group_id where $1 like pattern||'%'" ++ 
    %    " and enabled order by prio desc;", [ Num ] ),
    %Res=equery( "select * from (SELECT m.id,prio,m.modem_id,interface from route r "++
    %    "inner join group_extra_members e on e.group_id=r.group_id inner join "++
    %    "group_members m on m.id=e.modem_id where e.class_id=100 and  $1 like "++
    %    "pattern||'%' and enabled union SELECT m.id,prio,modem_id,interface "++
    %    "from route r inner join group_members m on m.group_id=r.group_id where "++
    %    "$2 like pattern||'%' and enabled) un order by prio desc; ", [ Num, Num] ),
    Res=equery("SELECT m.id,prio,m.modem_id,interface from route r "++
        "inner join group_extra_members e on e.group_id=r.group_id inner join "++
        "group_members m on m.id=e.modem_id where e.class_id=$1 and "++
        "$2 like pattern||'%' and enabled order by prio desc;",[Class,Num]),
    case Res of
        {ok,_,[]} ->
            {-1, undef, undef, Dict};
        {ok,_,M} when is_list(M) ->
            [{_,Pri,_,_}|_]=M,
            L2=lists:filter(fun({_,NPrio,_,_}) -> NPrio==Pri end, M),
            %lager:info("~p~n",[L2]),
            Fx=fun({NID,_,NChan,NInt},{_OID,OChan, _OInt, Dict0} = Acc) -> 
%                    io:format("~p ~p~n",[{NPrio,NChan,NInt},{OChan, OInt}]),
                    case OChan of
                        undef ->
                            case dict:is_key(NID,Dict) of
                                true ->
                                    Acc;
                                false ->
                                    {NID,NChan,binary_to_list(NInt), dict:store(NID,Num,Dict0)}
                            end;
                        _ -> 
                            Acc
                    end
            end,
            Res1=lists:foldl(Fx,{undef,undef,undef,Dict},L2),
%            lager:info("Res: ~p",[dict:to_list(Res1)]),
            %{_,_,_,TD} = Res1,
            %lager:info("Res: ~p",[dict:to_list(TD)]),
            Res1
    end;
get_channel(Num,Dict,dos,Class) ->
    Res=equery( "SELECT id, dosprio, modem_id,interface from group_members m where usefordos= $1 order by dosprio desc;", [ true ] ),
    case Res of
        {ok,_,[]} ->
            %{-1, undef, undef, Dict}; %class fix
            get_channel(Num,Dict,normal,Class); %class fix
        {ok,_,M} when is_list(M) ->
            Fx=fun({NID,_,NChan,NInt},{_OID,OChan, _OInt, Dict0} = Acc) -> 
                    case OChan of
                        undef ->
                            case dict:is_key(NID,Dict) of
                                true ->
                                    Acc;
                                false ->
                                    {NID,NChan,binary_to_list(NInt), dict:store(NID,Num,Dict0)}
                            end;
                        _ -> 
                            Acc
                    end
            end,
            Res1=lists:foldl(Fx,{undef,undef,undef,Dict},M),
            case Res of
                {undef,undef,undef,_} ->
                    Res2=get_channel(Num,Dict,normal,Class),
                    %lager:info("Res2: ~p",[Res2]),
                    Res2;
                _ ->
                    %lager:info("Res1: ~p",[Res1]),
                    Res1
            end
    end.



try_run_job(PArg,State) ->
    case PArg of 
        {A1,A2,A3,A4,A5,A6,A7} ->
            Jid=list_to_integer(binary_to_list(A1)),
            Maxlines=list_to_integer(binary_to_list(A6)),
            Class=list_to_integer(binary_to_list(A7)),
            Num=binary_to_list(A3),
            Nid=list_to_integer(binary_to_list(A2)),
            case Maxlines of 
                1 ->
                    case dict:find({job,Jid},State#state.dict) of
                        {ok, _Job} ->
                            {already_running,State};
                        error ->
                            {NID,NChan,NInt,NLock}=get_channel(Num,State#state.lock, normal, Class),
                            case NChan of
                                undef ->
                                    {everything_busy, State};
                                _ ->
                                    Tgt=binary_to_list(A5),

                                    {Tex, Tco } = case string:tokens(Tgt,"@") of
                                        [ X ] ->
                                            { X, "advert" };
                                        [ X , Y ] ->
                                            { X, Y };
                                        _ ->
                                            { "000", "advert" }
                                    end,
                                    Cdrfile=io_lib:format("~w-~w",[Jid,timer:now_diff(now(), {0,0,0}) div 1000000]),
                                    Arg=[{ext,Num},{grp,NChan},{modemid,NID},{timeout,60000*7},{target,Tex},{context,Tco},{channel,NInt},
                                        {cdrfile,Cdrfile}],
                                    case runJob(Jid,Arg) of 
                                        {ok, Pid} ->
                                            meteor:json("push",[{"dtype","job_run"},{"did",Jid},{"nid",Nid},{"number",Num}]),
                                            S1=State#state.dict,
                                            S2=dict:store({job,Jid},#job{
                                                    pid=Pid,
                                                    jid=Jid,
                                                    nid=Nid,
                                                    data=Arg,
                                                    chid=NID,
                                                    rec=Cdrfile,
                                                    tpl=list_to_integer(binary_to_list(A4))
                                                },S1),
                                            S3=S2,
                                         %   S3=dict:store({pid,Pid},Jid,S2),
                                            {ok,State#state{dict=S3,lock=NLock}};
                                        _ ->
                                            {cant_run,State}
                                    end
                            end
                end;
            _ ->
                case dict:find({job,{Jid, Nid}},State#state.dict) of
                    {ok, _Job} ->
                        {already_running,State};
                    error ->
                        NumJob= case dict:find({njob,Jid},State#state.dict) of
                            {ok, Jnum} ->
                                Jnum;
                            _ ->
                                0
                        end,
                        case NumJob<Maxlines of
                            true ->
                                {NID,NChan,NInt,NLock}=get_channel(Num,State#state.lock, dos, Class),
                                case NChan of
                                    undef ->
                                        {everything_busy, State};
                                    _ ->
                                        Tgt=binary_to_list(A5),

                                        {Tex, Tco } = case string:tokens(Tgt,"@") of
                                            [ X ] ->
                                                { X, "advert" };
                                            [ X , Y ] ->
                                                { X, Y };
                                            _ ->
                                                { "000", "advert" }
                                        end,
                                        Cdrfile=io_lib:format("~w-~w",[Jid,timer:now_diff(now(), {0,0,0}) div 1000000]),
                                        Arg=[{ext,Num},{grp,NChan},{modemid,NID},{timeout,60000*7},{target,Tex},{context,Tco},{channel,NInt},
                                            {cdrfile,Cdrfile}],
                                        case runJob ({Jid,Nid},Arg) of 
                                            {ok, Pid} ->
                                                meteor:json("push",[{"dtype","job_run"},{"did",Jid},{"nid",Nid},{"number",Num}]),
                                                S1=State#state.dict,
                                                S2=dict:store({job,{Jid,Nid}},#job{
                                                        pid=Pid,
                                                        jid=Jid,
                                                        nid=Nid,
                                                        data=Arg,
                                                        chid=NID,
                                                        rec=Cdrfile,
                                                        tpl=list_to_integer(binary_to_list(A4))
                                                    },S1),
%                                                S3=dict:store({pid,Pid},{Jid,Nid},S2),
                                                S3=S2,
                                                S4=dict:store({njob,Jid},NumJob+1,S3),

                                                {ok,State#state{dict=S4,lock=NLock}};
                                            _ ->
                                                {cant_run,State}
                                        end
                                end;


                            _ ->
                                {already_running,State}
                        end
                end
        end;
    _ -> 
            {badarg, State}
    end.


iter_jobs([],State) ->
   State; 

iter_jobs([R|X],State) ->
    %{Jid,Nid,Num,_Tpl,Tgt,MaxLines}=R,
    %lager:info("Call job ~p, number ~p: ~p to ~p  (max ~p) ~n",[Jid,Nid,Num,Tgt,MaxLines]),
    {_,St1}=try_run_job(R,State),
    iter_jobs(X,St1).

handle_info(queue_run, State) ->
    lager:debug("Queue run",[]),
    L="SELECT j.id, jn.id,jn.number,t.id,t.exten, case when dos=true then dos_lines else 1 end as maxlines, class_id " ++
        "from job j inner join job_numbers jn on jn.job_id=j.id " ++
        "inner join template t on t.id=j.template_id where " ++
        "now()::time between allowed_times and allowed_timee and " ++
        "jn.active=true and  (j.next_try is null or j.next_try <now()) and " ++
        "(jn.next_try is null or jn.next_try <now()) and j.active=true "++
        "order by jn.last_attempt asc nulls first;",

    case squery(L) of
        {ok, _X, Res} ->
%            lager:info("Call job ~p ~n",[Res]),
            case Res of
                [] ->
                    erlang:send_after(30000, self(), queue_run),
                    {noreply, State};
                [_|_] ->
                    J=iter_jobs(Res,State),
                    %lager:info("Prestate ~p",[State#state.dict]),
                    %lager:info("Afterstate ~p",[J#state.dict]),
                    erlang:send_after(5000, self(), queue_run),
                    {noreply, J}
            end;
        {error, Er} ->
            lager:error("Call job error: ~p",[Er]),
            {noreply, State}
    end;

handle_info({job_complete, Jid, Job}, State) ->
    lager:info("Job complete ~p ~n",[Job]),
    {noreply, complete_job(Jid,Job,State)};

handle_info({job_error, Jid, Job}, State) ->
    lager:info("Job complete ~p with error ~n",[Job]),
    {noreply, complete_job(Jid,Job,State)};

handle_info(Info, State) ->
    lager:error("Unknown signal ~p ~n",[Info]),
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

%% Private

%gettype(X) when is_boolean(X) -> boolean;
%gettype(X) when is_bitstring(X) -> bitstring;
%gettype(X) when is_float(X) -> float;
%gettype(X) when is_function(X) -> function;
%gettype(X) when is_integer(X) -> integer;
%gettype(X) when is_list(X) -> list;
%gettype(X) when is_number(X) -> number;
%gettype(X) when is_pid(X) -> pid;
%gettype(X) when is_port(X) -> port;
%gettype(X) when is_reference(X) -> reference;
%gettype(X) when is_tuple(X) -> tuple;
%gettype(_X) -> other.
mergedb_parseinterval({{Ch,Cm,Cs},CD,CM}) ->
    Str=[case CM of 
            0 ->
                "";
            _ ->
                integer_to_list(CM)++" mon "
        end,
        case CD of 
            0 ->
                "";
            1 -> 
                "1 day ";
            _ ->
                integer_to_list(CD)++" days "
        end,
        case {Ch,Cm,Cs} of 
            {0,0,_} ->
                integer_to_list(trunc(Cs))++" sec";
            {0,_,0} ->
                integer_to_list(Cm)++" min";
            {1,0,0} ->
                "1 hour";
            {_,0,0} ->
                integer_to_list(Ch)++" hours";
            {_,_,_} ->
                io_lib:format("~2..0w:~2..0w:~2..0w",[Ch,Cm,trunc(Cs)])
        end
    ],
    lists:flatten(Str).


mergedb([],[]) ->
    [];

mergedb([{column,Name,Type,_,_,_}|Xl],[Cs|Y]) ->
    %lager:info("MergeDB ~p ~p ~p ~p~n",[Name,Type,gettype(Cs),Cs]),
    C1=case Cs of
        X when is_bitstring(X) ->
            binary_to_list(X);
        X when is_binary(X) ->
            binary_to_list(X);
        X when is_integer(X) ->
            X;
        null ->
            null;
        X when is_atom(X) ->
            atom_to_list(X);
        _ ->
           Cs
    end,
    %lager:info("converted to ~p ~p~n",[gettype(C1),C1]),
    MyRes=case Type of
        int8 ->
            case C1 of
                null ->
                    {binary_to_list(Name),null};
                CX when is_integer(CX) ->
                    {binary_to_list(Name),CX};
                CX when is_list(CX) ->
                    {binary_to_list(Name),list_to_integer(CX)}
            end;
        bool ->
            case C1 of
                "t" ->
                    {binary_to_list(Name),1};
                "true" -> 
                    {binary_to_list(Name),1};
                "f" -> 
                    {binary_to_list(Name),0};
                "false" -> 
                    {binary_to_list(Name),0};
                _ -> 
                    {binary_to_list(Name),null}
            end;
        interval ->
            case C1 of
                {{_,_,_},_,_} ->
                    {binary_to_list(Name),mergedb_parseinterval(C1)};
                CAll1 when is_list(CAll1) ->
                    {binary_to_list(Name),CAll1};
                _ ->
                    {binary_to_list(Name),"error"}
            end;
         timestamp ->
            case C1 of
                {{CdY,CdM,CdD},{Cdh,Cdm,Cds}} ->
                    _Month=case CdM of
                                    1 -> "Jan";
                                    2 -> "Feb";
                                    3 -> "Mar";
                                    4 -> "Apr";
                                    5 -> "May";
                                    6 -> "Jun";
                                    7 -> "Jul";
                                    8 -> "Aug";
                                    9 -> "Sep";
                                    10 -> "Oct";
                                    11 -> "Nov";
                                    12 -> "Dec";
                                    _ -> "___"
                            end,
                    {binary_to_list(Name),io_lib:format("~4..0w-~2..0w-~2..0w ~2..0w:~2..0w:~2..0w",[CdY,CdM,CdD,Cdh,Cdm,trunc(Cds)])};
                CAll when is_list(CAll) ->
                    {binary_to_list(Name),CAll};
                _ ->
                    {binary_to_list(Name),"error"}
            end;
        _ ->
            {binary_to_list(Name),C1}
    end,
    %lager:info("res ~p~n",[MyRes]),
    [MyRes|mergedb(Xl,Y)].



field1(Field,Arg,False) ->
    case lists:keyfind(Field,1,Arg) of
        {Field, Data} ->
            Data;
        _ -> 
            False
    end.

lookup_tpl_act(Tpl,Res,IvrRes) ->
    TO=equery("SELECT continue,extract(epoch from npause),extract(epoch from pause),info,warning,result_id from template_actions where template_id=$1 and result_id="++
        "(SELECT id from call_result where result=$2 and (ivrres=$3 or ivrres is null) order by ivrres limit 1);",
        [Tpl,Res,IvrRes]),
    case TO of
        {ok, _, [{C,N,P,I,W,R}]} ->
            lager:info("Job result (~p,~p,~p) = ~p (~p, ~p, ~p, ~p, ~p)",[Tpl,Res,IvrRes,R,C,N,P,I,W]),
            {C,erlang:trunc(N),erlang:trunc(P),I,W};
        _ ->
            lager:info("Job result (~p,~p,~p) not found",[Tpl,Res,IvrRes]),
            {true,3600,3600,true,false} 
    end.

complete_job(Jid,Data,State) ->
    lager:info("complete_job ~p~n~p~n",[Jid,Data]),
    lager:info("State ~p",[State#state.dict]),
    case dict:find({job,Jid},State#state.dict) of
        {ok, Job} ->
            XJid=case Jid of 
                { X1Jid, _XNid } -> X1Jid;
                _ -> Jid
            end,
            lager:info("Jid ~p template ~p",[Jid,Job#job.tpl]),

            {Myres,Nexttry,Gtry,Cont,Info,Warn}=case {
                    field1(status,Data,none),
                    field1(res_txt,Data,none),
                    field1(res_num,Data,none)
                } of
                {hup, "Success", "4"} ->
                    F1=case field1(ivrres,Data,null) of
                        null -> "x";
                        NotNull -> NotNull
                    end,
                    {ZCont,ZNPause,ZPause,ZInfo,ZWarn}=lookup_tpl_act(Job#job.tpl,"Success",F1),
                    {"Success", ZNPause, ZPause, ZCont, ZInfo, ZWarn};
                {timeout, _, _ } ->
                    {"Timeout", 60, false};
                {res, "Failure", "5" } ->
                    {ZCont,ZNPause,ZPause,ZInfo,ZWarn}=lookup_tpl_act(Job#job.tpl,"Busy",null),
                    {"Busy", ZNPause, ZPause, ZCont, ZInfo, ZWarn};
                {res, "Failure", "3" } ->
                    {ZCont,ZNPause,ZPause,ZInfo,ZWarn}=lookup_tpl_act(Job#job.tpl,"NotAnswer",null),
                    {"NotAnswer", ZNPause, ZPause, ZCont, ZInfo, ZWarn};
                {res, "Failure", "8" } ->
                    {ZCont,ZNPause,ZPause,ZInfo,ZWarn}=lookup_tpl_act(Job#job.tpl,"Congestion",null),
                    {"Congestion", ZNPause, ZPause, ZCont, ZInfo, ZWarn};
                _ ->
                    {ZCont,ZNPause,ZPause,ZInfo,ZWarn}=lookup_tpl_act(Job#job.tpl,"Congestion",null),
                    {"Unknown", ZNPause, ZPause, ZCont, ZInfo, ZWarn}
            end,
            lager:info("complete ~p ~p ~p ~p cont ~s ~n",
                [Myres,lager:pr(Job,?MODULE),Nexttry,Gtry,Cont]),
            R0a=equery( "insert into job_log(job_id,number_id,result,duration,ivrres,recfile,modem_id) values($1,$2,$3,$4*'1 sec'::interval,$5,$6,$7) returning id",
                [ Job#job.jid, Job#job.nid, Myres, case field1(duration,Data,null) of undef -> null; S -> S end,field1(ivrres,Data,null),Job#job.rec,field1(modemid,Data,null)]
            ),
            lager:info("R0: ~p~n",[R0a]),
            {ok, _, _, [{LogId}]} = R0a,

            QFields=["job_log.id", "job_log.job_id", "job_log.number_id", "job_log.t", "job_log.result", "job_log.duration", "job.description", "job_numbers.number"],
            QFields1=lists:flatten([ X ++ " as \"" ++ X ++ "\"," || X <- QFields]),
            QFields2=lists:sublist(QFields1,length(QFields1)-1),

            R0b=equery(
                "select "++QFields2++
                " from job_log left join job on job.id=job_log.job_id "++
                "left join job_numbers on job_numbers.id=job_log.number_id where job_log.id=$1" ,
                [ LogId]
            ),
            %lager:info("R0: ~p~n",[R0b]),
            {ok, C0, [V0]} = R0b,
            T0=[{"dtype","job_log"}|mergedb(C0,tuple_to_list(V0))],
            meteor:json("push",T0),

            lager:info("update num Jid#~p=~p, Nid#~p=~p",[ Job#job.jid, Gtry, Job#job.nid, Nexttry  ]),
            equery( 
                "update job_numbers set last_attempt=now(), last_result=$1, next_try=now()+$4*'1 sec'::interval where job_id=$2 and id=$3",
                [ Myres, Job#job.jid, Job#job.nid, Nexttry ]),

            Q1="select id,number,last_attempt,last_result,active,next_try"++
                    " from job_numbers where id=" ++
                    integer_to_list(Job#job.nid) ++ ";",
            R1=squery(Q1),
            {ok, C1, [V1]} = R1,
            lager:info("serialize ~p~n~p~n",[C1,V1]),
            T1=[{"dtype","job_number"},{"did",XJid}|mergedb(C1,tuple_to_list(V1))],
            meteor:json("push",T1),


            case is_integer(Gtry) of 
                true -> 
                    case Gtry > 0 of
                        true ->
                            M=equery( 
                                "update job set next_try=now()+$1*'1 sec'::interval, active=active and $3 where id=$2",
                                [ Gtry, Job#job.jid, Cont ]),
                            Q2="select id,description,allowed_times," ++
                                    "allowed_timee, interval_success, interval_busy," ++
                                    "interval_na, next_try, target, active " ++
                                    " from job where id=" ++
                                    integer_to_list(XJid) ++ ";",
                            R2=squery(Q2),
                            {ok, C2, [V2]} = R2,
                            %lager:info("serialize ~p~n~p~n",[C2,V2]),
                            T2=[{"dtype","job"},{"did",XJid}|mergedb(C2,tuple_to_list(V2))],
                            meteor:json("push",T2),
                            M;
                        _ -> ok
                    end;
                _ -> ok
            end,
            meteor:json("push",[{"dtype","job_end"},{"did",XJid},{"nid",Job#job.nid},{"res",Myres}]),
                case Warn or Info of
                    true ->
                        R3=equery(
                            "insert into notification(job_id,number_id,result,ivrres,warning) values($1,$2,$3,$4,$5) returning id",
                            [ Job#job.jid, Job#job.nid, Myres, field1(ivrres,Data,null), Warn]
                        ),
                        {ok, _, _, [{NotId}]} = R3,


                        Q1Fields=["notification.id", "notification.job_id", "notification.number_id", "notification.t", "notification.result", "job.description", "job_numbers.number", "notification.warning", "notification.ivrres"],
                        Q1Fields1=lists:flatten([ X ++ " as \"" ++ X ++ "\"," || X <- Q1Fields]),
                        Q1Fields2=lists:sublist(Q1Fields1,length(Q1Fields1)-1),

                        R3b=equery(
                            "select "++Q1Fields2++
                            " from notification left join job on job.id=notification.job_id "++
                            "left join job_numbers on job_numbers.id=notification.number_id where notification.id=$1" ,
                            [ NotId]
                        ),

                        %R3b=equery( "select * from notification where id=$1", [ NotId]),
                        lager:info("R0: ~p~n",[R3b]),
                        {ok, C3, [V3]} = R3b,
                        T3=[{"dtype","notification"}|mergedb(C3,tuple_to_list(V3))],
                        meteor:json("push",T3),
                        ok;
                    _ ->
                        ok
                end,

                %lager:info("R0: ~p~n",[R0a]),
                %                {ok, _, _, [{LogId}]} = R0a,

                D1=dict:erase({job, Jid}, State#state.dict),
                D2=case Jid of 
                    {_, _} ->
                        case dict:find({njob,XJid},D1) of
                            {ok, Jnum} ->
                                dict:store({njob,XJid},Jnum-1,D1);
                            _ ->
                                D1
                        end;
                    _ ->
                        D1
                end,
                L2=dict:erase(Job#job.chid, State#state.lock),
%                erlang:send_after(100, self(), queue_run),
                State#state{dict=D2,lock=L2};
            error ->
                State;
            _ ->
                State
        end.

equery(Sql, Args) ->
    lager:info("aSQL: ~p, Args ~p",[Sql,Args]),
    poolboy:transaction(auth_db_worker, fun(Worker) ->
        gen_server:call(Worker, {equery, Sql, Args}, 10000)
    end).

squery(Sql) ->
    lager:info("SQL: ~p",[Sql]),
    poolboy:transaction(auth_db_worker, fun(Worker) ->
        gen_server:call(Worker, {squery, Sql}, 10000)
    end).

getpwuser(Username, Domain) ->
    {ok, _, Res} = equery("select uid from domains where name='$1';",[Domain]),
    case Res of
	[] ->
	    {error, unknown_realm};
	[{DID}] ->
	    Query="select uid, password from users where username='"
            ++ Username ++ "' and domain_id=" ++ binary_to_list(DID)
            ++ ";",
%%	    io:format("Query: ~p~n",[Query]),
	    {ok, _, User} = squery(Query),
	    case User of 
		[] ->
		    {error, no_such_user};
		[{Uid,Upw}] ->
		    {ok, {Uid, Upw}}
	    end
    end.

