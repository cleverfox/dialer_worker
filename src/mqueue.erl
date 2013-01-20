-module(mqueue).
-behaviour(gen_server).

-compile([{parse_transform, lager_transform}]).
%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
	 terminate/2, code_change/3]).

-export([authenticate/1,ping/1]).
-export([squery/1]).

-define(SERVER, ?MODULE). 

-record(state, {dict}).
-record(job, {jid,nid,pid,data,is,ib,in}).

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
    erlang:send_after(10000, self(), queue_run),
    {ok, #state{dict=dict:new()}}.

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
try_run_job(PArg,State) ->
    case PArg of 
        {A1,A2,A3,Is,Ib,In,A7} ->
            Jid=list_to_integer(binary_to_list(A1)),
            Nid=list_to_integer(binary_to_list(A2)),
            Tgt=binary_to_list(A7),
            Num=binary_to_list(A3),
            case dict:find({job,Jid},State#state.dict) of
                {ok, _Job} ->
                    {already_running,State};
                error ->
                    {Tex, Tco } = case string:tokens(Tgt,"@") of
                        [ X ] ->
                            { X, "dialout" };
                        [ X , Y ] ->
                            { X, Y }
                    end,
                    Arg=[{ext,Num},{grp,"2"},{timeout,60000},{target,Tex},{context,Tco}],
                    case calljob:run(Jid,Arg) of 
                        {ok, Pid} ->
                            S1=State#state.dict,
                            S2=dict:store({job,Jid},#job{
                                    pid=Pid,
                                    jid=Jid,
                                    nid=Nid,
                                    data=Arg,
                                    is=list_to_integer(binary_to_list(Is)),
                                    ib=list_to_integer(binary_to_list(Ib)),
                                    in=list_to_integer(binary_to_list(In))
                                },S1),
                            S3=dict:store({pid,Pid},Jid,S2),
                            {ok,State#state{dict=S3}};
                        _ ->
                            {cant_run,State}
                    end
            end;
        _ -> 
            {error, badarg}
    end.


iter_jobs([],State) ->
   State; 

iter_jobs([R|X],State) ->
    {Jid,Nid,Num,_Is,_Ib,_In,Tgt}=R,
    lager:info("Call job ~p, number ~p: ~p to ~p ~n",[Jid,Nid,Num,Tgt]),
    {_,St1}=try_run_job(R,State),
    iter_jobs(X,St1).

handle_info(queue_run, State) ->
    lager:info("Queue run~n",[]),
    L=["SELECT ",
        "j.id,jn.id,jn.number,",
        "EXTRACT(EPOCH FROM j.interval_success),",
        "EXTRACT(EPOCH FROM j.interval_busy),",
        "EXTRACT(EPOCH FROM j.interval_na),",
        "target ",
        " from job j inner join ",
        "job_numbers jn on jn.job_id=j.id where now()::time ",
        "between allowed_times and allowed_timee and ",
        " (j.next_try is null or j.next_try <now()) and ",
        " (jn.next_try is null or jn.next_try <now()) and ",
        " (j.next_number_id is null or j.next_number_id = jn.id)"],
    case squery(lists:flatten(L)) of
        {ok, _X, Res} ->
            lager:info("Call job ~p ~n",[Res]),
            case Res of
                [] ->
                    erlang:send_after(5000, self(), queue_run),
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
            {noreply, State#state{dict=D3}};
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

field1(Field,Arg,False) ->
    case lists:keyfind(Field,1,Arg) of
        {Field, Data} ->
            Data;
        _ -> 
            False
    end.

complete_job(Jid,Data,State) ->
    lager:info("complete_job ~p ~n~p ~p~n",[Jid,Data,field1(nid,Data,not_found)]),
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
                    lager:info("complete ~p ~p ~p ~p ~n",[Myres,Job,Nexttry,Gtry]),
                    equery(
                        "insert into job_log(job_id,number_id,result,duration) values($1,$2,$3,$4*'1 sec'::interval)",
                        [ Job#job.jid, Job#job.nid, Myres, case field1(duration,Data,null) of undef -> null; S -> S end]
                    ),
                    lager:info("update num Jid#~p=~p, Nid#~p=~p",[ Job#job.jid, Gtry, Job#job.nid, Nexttry  ]),
                    equery( 
                        "update job_numbers set last_attempt=now(), last_result=$1, next_try=now()+$4*'1 sec'::interval where job_id=$2 and id=$3",
                        [ Myres, Job#job.jid, Job#job.nid, Nexttry ]),
                    case is_integer(Gtry) of 
                        true -> 
                            equery( 
                                "update job set next_try=now()+$1*'1 sec'::interval where id=$2",
                            [ Gtry, Job#job.jid ]);
                        _ -> ok
                    end,
                            
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

