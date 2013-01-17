-module(mqueue).
-behaviour(gen_server).

%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
	 terminate/2, code_change/3]).

-export([authenticate/1,ping/1]).
-export([squery/1]).

-define(SERVER, ?MODULE). 

-record(state, {dict}).
-record(job, {jid,nid,pid,data}).

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
    erlang:send_after(1000, self(), queue_run),
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
		    error_logger:info_msg("User ~p@~p: authentcation success~n",[Username,Domain]),
		    {reply, allow, State};
		false ->
		    error_logger:warning_msg("User ~p@~p: password incorrect~n",[Username,Domain]),
		    {reply, deny, State}
	    end;
	{error, Cause} ->
	     error_logger:warning_msg("User ~p@~p: auth error ~p~n",[Username,Domain,Cause]),
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
try_run_job({Jid,Nid,Num},State) ->
    case dict:find({job,Jid},State#state.dict) of
        {ok, _Job} ->
            {already_running,State};
        error ->
            case calljob:run(Jid,Nid,Num) of 
                {ok, Pid} ->
                    S1=State#state.dict,
                    S2=dict:store({job,Jid},#job{pid=Pid,jid=Jid,nid=Nid,data=Num},S1),
                    S3=dict:store({pid,Pid},Jid,S2),
                    {ok,State#state{dict=S3}};
                _ ->
                    {cant_run,State}
            end
    end.


iter_jobs([],State) ->
   State; 

iter_jobs([R|X],State) ->
    {Jid,Nid,Num}=R,
    log("Call job ~p, number ~p: ~p~n",[Jid,Nid,Num]),
    {_,St1}=try_run_job(R,State),
    iter_jobs(X,St1).

handle_info(queue_run, State) ->
    log("Queue run~n",[]),
    L=["SELECT j.id,jn.id,jn.number from job j inner join ",
        "job_numbers jn on jn.job_id=j.id where now()::time ",
        "between allowed_times and allowed_timee and (next_try ",
        "is null or next_try <now()) and (j.next_number_id is ",
        "null or j.next_number_id = jn.id)"],
    {ok, _X, Res} = squery(lists:flatten(L)),
    log("Call job ~p ~n",[Res]),
    case Res of
        [] ->
            erlang:send_after(5000, self(), queue_run),
            {noreply, State};
        [_|_] ->
            erlang:send_after(5000, self(), queue_run),
            {noreply, iter_jobs(Res,State)}
    end;

handle_info({'EXIT',Pid,_}, State) ->
    D1=State#state.dict,
    case dict:is_key({pid,Pid},D1) of
        true ->
            Jid=dict:fetch({pid,Pid},D1),
            Job=dict:fetch({job,Jid},D1),

            log("Calljob process ~p dead (~p)~n",[Pid,Job]),
            D2=dict:erase({pid, Pid}, D1),
            D3=dict:erase({job, Jid}, D2),

            {noreply, State#state{dict=D3}};
        false ->
            log("Dead unknown process ~p ~n",[Pid]),
            {noreply, State}
    end;

handle_info(Info, State) ->
    log("Unknown signal ~p ~n",[Info]),
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

%% Private

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

log (X,Y) ->
    io:format(X,Y).
