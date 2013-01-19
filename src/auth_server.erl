%%%-------------------------------------------------------------------
%%% @author Vladimir Goncharov <viruzzz@lnb.local>
%%% @copyright (C) 2012, Vladimir Goncharov
%%% @doc
%%%
%%% @end
%%% Created :  7 Aug 2012 by Vladimir Goncharov <viruzzz@lnb.local>
%%%-------------------------------------------------------------------
-module(auth_server).

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

-record(state, {}).

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
    {ok, #state{}}.

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
		    lager:error("User ~p@~p: password incorrect~n",[Username,Domain]),
		    {reply, deny, State}
	    end;
	{error, Cause} ->
	     lager:info("User ~p@~p: auth error ~p~n",[Username,Domain,Cause]),
	    {reply, deny, Cause}
    end;



handle_call({area, Thing}, _From, N) -> 
    {reply, {area,Thing}, N};

handle_call({myping, Data}, _From, State) ->
    {reply, {pong, Data}, State};

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
