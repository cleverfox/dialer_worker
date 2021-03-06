-module(auth_db_worker).
-behaviour(gen_server).
-behaviour(poolboy_worker).

-compile([{parse_transform, lager_transform}]).

-export([start_link/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2,
         code_change/3]).

-record(state, {conn}).

start_link(Args) ->
    gen_server:start_link(?MODULE, Args, []).

init(Args) ->
    Hostname = proplists:get_value(hostname, Args,
        case application:get_env(db_host) of {ok, Val1} -> Val1; _ -> false end),
    Database = proplists:get_value(database, Args,
        case application:get_env(db_name) of {ok, Val2} -> Val2; _ -> false end),
    Username = proplists:get_value(username, Args,
        case application:get_env(db_user) of {ok, Val3} -> Val3; _ -> false end),
    Password = proplists:get_value(password, Args,
        case application:get_env(db_pass) of {ok, Val4} -> Val4; _ -> false end),
    lager:info("Connect to database ~p@~p:~p~n",[Username,Hostname,Database]),
    case  pgsql:connect(Hostname, Username, Password, [ {database, Database} ]) of
        {ok, Conn} ->
            {ok, #state{conn=Conn}};
        {error, X} -> 
            lager:error("Can't connect to database ~p@~p:~p: ~p~n",[Username,Hostname,Database,X])
    end.

handle_call({squery, Sql}, _From, #state{conn=Conn}=State) ->
    {reply, pgsql:squery(Conn, Sql), State};
handle_call({equery, Stmt, Params}, _From, #state{conn=Conn}=State) ->
    {reply, pgsql:equery(Conn, Stmt, Params), State};
handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, #state{conn=Conn}) ->
    ok = pgsql:close(Conn),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}. 

