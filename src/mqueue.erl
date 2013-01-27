-module(mqueue).
-behaviour(gen_server).

-compile([{parse_transform, lager_transform}]).
%% API
-export([start_link/0,mergedb/2]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
	 terminate/2, code_change/3]).

-export([authenticate/1,ping/1]).
-export([squery/1,get_channel/2]).

-define(SERVER, ?MODULE). 

-record(state, {dict,lock}).
-record(job, {jid,nid,pid,data,is,ib,in,chid}).

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
get_channel(Num,Dict) ->
    Res=equery( "SELECT m.id,prio,modem_id,interface from route r left join group_members m on m.group_id=r.group_id where $1 like pattern||'%' order by prio desc;", [ Num ] ),
    case Res of
        {ok,_,[]} ->
            {-1, undef, undef, Dict};
        {ok,_,M} when is_list(M) ->
            [{_,Pri,_,_}|_]=M,
            L2=lists:filter(fun({_,NPrio,_,_}) -> NPrio==Pri end, M),
            lager:info("~p~n",[L2]),
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
            lists:foldl(Fx,{undef,undef,undef,Dict},L2)
    end.



try_run_job(PArg,State) ->
    case PArg of 
        {A1,A2,A3,Is,Ib,In,A7} ->
            Jid=list_to_integer(binary_to_list(A1)),
            Num=binary_to_list(A3),
            case dict:find({job,Jid},State#state.dict) of
                {ok, _Job} ->
                    {already_running,State};
                error ->
                    {NID,NChan,NInt,NLock}=get_channel(Num,State#state.lock),
                    case NChan of
                        undef ->
                            {everything_busy, State};
                        _ ->
                            Nid=list_to_integer(binary_to_list(A2)),
                            Tgt=binary_to_list(A7),

                            {Tex, Tco } = case string:tokens(Tgt,"@") of
                                [ X ] ->
                                    { X, "advert" };
                                [ X , Y ] ->
                                    { X, Y };
                                _ ->
                                    { "000", "advert" }
                            end,
                            Arg=[{ext,Num},{grp,NChan},{modemid,NID},{timeout,60000},{target,Tex},{context,Tco},{channel,NInt}],
                            case calljob:run(Jid,Arg) of 
                                {ok, Pid} ->
                                    meteor:json("push",[{"dtype","job_run"},{"did",Jid},{"nid",Nid},{"number",Num}]),
                                    S1=State#state.dict,
                                    S2=dict:store({job,Jid},#job{
                                            pid=Pid,
                                            jid=Jid,
                                            nid=Nid,
                                            data=Arg,
                                            chid=NID,
                                            is=list_to_integer(binary_to_list(Is)),
                                            ib=list_to_integer(binary_to_list(Ib)),
                                            in=list_to_integer(binary_to_list(In))
                                        },S1),
                                    S3=dict:store({pid,Pid},Jid,S2),
                                    {ok,State#state{dict=S3,lock=NLock}};
                                _ ->
                                    {cant_run,State}
                            end
                    end
            end;
        _ -> 
            {badarg, State}
    end.


iter_jobs([],State) ->
   State; 

iter_jobs([R|X],State) ->
    {Jid,Nid,Num,_Is,_Ib,_In,Tgt}=R,
    lager:info("Call job ~p, number ~p: ~p to ~p ~n",[Jid,Nid,Num,Tgt]),
    {_,St1}=try_run_job(R,State),
    iter_jobs(X,St1).

handle_info(queue_run, State) ->
    %lager:info("Queue run~n",[]),
    L=["SELECT ",
        "j.id,jn.id,jn.number,",
        "EXTRACT(EPOCH FROM j.interval_success),",
        "EXTRACT(EPOCH FROM j.interval_busy),",
        "EXTRACT(EPOCH FROM j.interval_na),",
        "target ",
        " from job j inner join ",
        "job_numbers jn on jn.job_id=j.id where ",
        " now()::time between allowed_times and allowed_timee and ",
        " jn.active=true and ",
        " (j.next_try is null or j.next_try <now()) and ",
        " (jn.next_try is null or jn.next_try <now()) order by jn.last_attempt asc" ],
%    lager:info("SQL: ~p",[lists:flatten(L)]),
    case squery(lists:flatten(L)) of
        {ok, _X, Res} ->
%            lager:info("Call job ~p ~n",[Res]),
            case Res of
                [] ->
                    erlang:send_after(10000, self(), queue_run),
                    {noreply, State};
                [_|_] ->
                    erlang:send_after(30000, self(), queue_run),
                    {noreply, iter_jobs(Res,State)}
            end;
        {error, Er} ->
            lager:error("Call job error: ~p",[Er]),
            {noreply, State}
    end;

handle_info({ch_sta,Pid,Info}, State) ->
    D1=State#state.dict,
    case dict:is_key({pid,Pid},D1) of
        true ->
            Jid=dict:fetch({pid,Pid},D1),
            Job=dict:fetch({job,Jid},D1),

            lager:info("Calljob process ~p (~p) Stat ~p~n",[Pid,Job,Info]),
            D2=dict:erase({pid, Pid}, D1),
            D3=dict:erase({job, Jid}, D2),

            {noreply, State#state{dict=D3}};
        false ->
            lager:info("sta unknown process ~p ~n",[Pid]),
            {noreply, State}
    end;
handle_info({'EXIT',Pid,_}, State) ->
    D1=State#state.dict,
    case dict:is_key({pid,Pid},D1) of
        true ->
            Jid=dict:fetch({pid,Pid},D1),
            Job=dict:fetch({job,Jid},D1),
            lager:info("Calljob process ~p dead (~p)~n",[Pid,Job]),
            D2=dict:erase({pid, Pid}, D1),
            D3=dict:erase({job, Jid}, D2),
            L2=dict:erase(Job#job.chid, State#state.lock),
            {noreply, State#state{dict=D3,lock=L2}};
        false ->
            lager:info("Dead unknown process ~p ~n",[Pid]),
            {noreply, State}
    end;

handle_info({job_complete, Jid, Job}, State) ->
    lager:info("Job complete ~p ~n",[Job]),
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
                {{CY,CM,CD},{Ch,Cm,Cs}} ->
                    {binary_to_list(Name),io_lib:format("~p ~p ~p ~p:~p~i",[CD,CM,CY,Ch,Cm,Cs])};
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

complete_job(Jid,Data,State) ->
    lager:info("complete_job ~p ~n~p~n",[Jid,Data]),
    case dict:find({job,Jid},State#state.dict) of
                {ok, Job} ->
                    {Myres,Nexttry,Gtry}=case {
                            field1(status,Data,none),
                            field1(res_txt,Data,none),
                            field1(res_num,Data,none)
                        } of
                        {hup, "Success", "4"} ->
                            {"Success", Job#job.is, Job#job.is};
                        {timeout, _, _ } ->
                            {"Timeout", 5, false};
                        {res, "Failure", "5" } ->
                            {"Busy", Job#job.ib, false};
                        {res, "Failure", "3" } ->
                            {"NotAnswer", Job#job.in, false};
                        {res, "Failure", "8" } ->
                            {"Congestion", Job#job.in, false};
                        _ ->
                            {"Unknown",null,0}
                    end,
                    %lager:info("complete ~p ~p ~p ~p ~n",[Myres,Job,Nexttry,Gtry]),
                    R0a=equery(
                        "insert into job_log(job_id,number_id,result,duration,ivrres) values($1,$2,$3,$4*'1 sec'::interval,$5) returning id",
                        [ Job#job.jid, Job#job.nid, Myres, case field1(duration,Data,null) of undef -> null; S -> S end,field1(ivrres,Data,null)]
                    ),
                    %lager:info("R0: ~p~n",[R0a]),
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

                    Q1=lists:flatten(["select id,number,last_attempt,last_result,active,next_try",
                            " from job_numbers where id=", integer_to_list(Job#job.nid), ";"]),
                    R1=squery(Q1),
                    {ok, C1, [V1]} = R1,
                    lager:info("serialize ~p~n~p~n",[C1,V1]),
                    T1=[{"dtype","job_number"},{"did",Jid}|mergedb(C1,tuple_to_list(V1))],
                    meteor:json("push",T1),


                    case is_integer(Gtry) of 
                        true -> 
                            M=equery( 
                                "update job set next_try=now()+$1*'1 sec'::interval where id=$2",
                                [ Gtry, Job#job.jid ]),
                            Q2=lists:flatten(["select id,description,allowed_times,",
                                    "allowed_timee, interval_success, interval_busy,",
                                    "interval_na, next_try, target ",
                                    " from job where id=", integer_to_list(Jid), ";"]),
                            R2=squery(Q2),
                            {ok, C2, [V2]} = R2,
                            lager:info("serialize ~p~n~p~n",[C2,V2]),
                            T2=[{"dtype","job"},{"did",Jid}|mergedb(C2,tuple_to_list(V2))],
                            meteor:json("push",T2),
                            M;
                        _ -> ok
                    end,
                    meteor:json("push",[{"dtype","job_end"},{"did",Jid},{"nid",Job#job.nid},{"res",Myres}]),
                            
                    State;
                error ->
                    State
    end.

equery(Sql, Args) ->
    poolboy:transaction(auth_db_worker, fun(Worker) ->
        gen_server:call(Worker, {equery, Sql, Args})
    end).

squery(Sql) ->
    poolboy:transaction(auth_db_worker, fun(Worker) ->
        gen_server:call(Worker, {squery, Sql})
    end).

getpwuser(Username, Domain) ->
    {ok, _, Res} = equery("select uid from domains where name='$1';",[Domain]),
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

