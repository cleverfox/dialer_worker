%%%-------------------------------------------------------------------
%%% @author Vladimir Goncharov <viruzzz@lnb.local>
%%% @copyright (C) 2012, Vladimir Goncharov
%%% @doc
%%%
%%% @end
%%% Created :  5 Aug 2012 by Vladimir Goncharov <viruzzz@lnb.local>
%%%-------------------------------------------------------------------
-module(dialer_app).

-behaviour(application).

%% Application callbacks
-export([start/0, start/2, stop/1, init/1]).
-export([start_client/0]).
-export([get_app_env/2]).

-define(MAX_RESTART,    5).
-define(MAX_TIME,      60).

%%%===================================================================
%%% Application callbacks
%%%===================================================================

start_client() ->
    supervisor:start_child(tcp_client_sup, []).


%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called whenever an application is started using
%% application:start/[1,2], and should start the processes of the
%% application. If the application is structured according to the OTP
%% design principles as a supervision tree, this means starting the
%% top supervisor of the tree.
%%
%% @spec start(StartType, StartArgs) -> {ok, Pid} |
%%                                      {ok, Pid, State} |
%%                                      {error, Reason}
%%      StartType = normal | {takeover, Node} | {failover, Node}
%%      StartArgs = term()
%% @end
%%--------------------------------------------------------------------
start() ->
    application:start(dialer).

start(_StartType, _StartArgs) -> 
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).


%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called whenever an application has stopped. It
%% is intended to be the opposite of Module:start/2 and should do
%% any necessary cleaning up. The return value is ignored.
%%
%% @spec stop(State) -> void()
%% @end
%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%%===================================================================
%%% Internal functions
%%%===================================================================

%%----------------------------------------------------------------------
%% Supervisor behaviour callbacks
%%----------------------------------------------------------------------
init([]) ->
    {ok,
     {_SupFlags = {one_for_one, ?MAX_RESTART, ?MAX_TIME},
      [
						% TCP Listener
%       {   lager,                          % Id       = internal id
%	   {lager,start,[]}, % StartFun = {M, F, A}
%	   permanent,                               % Restart  = permanent | transient | temporary
%	   2000,                                    % Shutdown = brutal_kill | int() >= 0 | infinity
%	   worker,                                  % Type     = worker | supervisor
%         [lager]                           % Modules  = [Module] | dynamic
%      },

%       {   tcp_server_sup,                          % Id       = internal id
%	   {tcp_listener,start_link,[Port,Module]}, % StartFun = {M, F, A}
%	   permanent,                               % Restart  = permanent | transient | temporary
%	   2000,                                    % Shutdown = brutal_kill | int() >= 0 | infinity
%	   worker,                                  % Type     = worker | supervisor
%         [tcp_listener]                           % Modules  = [Module] | dynamic
%      },

						% Client instance supervisor
%       {   tcp_client_sup,
%	   {supervisor,start_link,[{local, tcp_client_sup}, ?MODULE, [Module]]},
%	   permanent,                               % Restart  = permanent | transient | temporary
%	   infinity,                                % Shutdown = brutal_kill | int() >= 0 | infinity
%	   supervisor,                              % Type     = worker | supervisor
%	   []                                       % Modules  = [Module] | dynamic
 %      },

       {   mqueue,                             % Id       = internal id
           {mqueue,start_link, [] },             % StartFun = {M, F, A}
           permanent,                               % Restart  = permanent | transient | temporary
           2000,                                    % Shutdown = brutal_kill | int() >= 0 | infinity
           worker,                                  % Type     = worker | supervisor
           [mqueue]                            % Modules  = [Module] | dynamic
       },


      {   ami_server,                             % Id       = internal id
           {ami_server,start_link,
               [env,env,env,env]
           },             % StartFun = {M, F, A}
           permanent,                               % Restart  = permanent | transient | temporary
           2000,                                    % Shutdown = brutal_kill | int() >= 0 | infinity
           worker,                                  % Type     = worker | supervisor
           [ami_server]                            % Modules  = [Module] | dynamic
       },

      {   meteor,                             % Id       = internal id
           {meteor,start_link,
               [env,env]
           },             % StartFun = {M, F, A}
           permanent,                               % Restart  = permanent | transient | temporary
           2000,                                    % Shutdown = brutal_kill | int() >= 0 | infinity
           worker,                                  % Type     = worker | supervisor
           [meteor]                            % Modules  = [Module] | dynamic
       },


       {   auth_server,                             % Id       = internal id
	   {auth_server,start_link,[]},             % StartFun = {M, F, A}
	   permanent,                               % Restart  = permanent | transient | temporary
	   2000,                                    % Shutdown = brutal_kill | int() >= 0 | infinity
	   worker,                                  % Type     = worker | supervisor
	   [auth_server]                            % Modules  = [Module] | dynamic
       },

       {   auth_db_worker,                             % Id       = internal id
	   {poolboy,start_link,[
	       	 [{name,{local,auth_db_worker}},
                  {worker_module,auth_db_worker},
                  {size,5},
                  {max_overflow,20},
                  %{hostname,"192.168.2.15"},
                  %{database,"caller"},
                  %{username,"pgsql"},
                  %{password,""}
                  {pad,pad}
              ]
          ]},             % StartFun = {M, F, A}
	   permanent,                               % Restart  = permanent | transient | temporary
	   5000,                                    % Shutdown = brutal_kill | int() >= 0 | infinity
	   worker,                                  % Type     = worker | supervisor
	   [poolboy]                            % Modules  = [Module] | dynamic
       }


%       {   database_server,                         % Id       = internal id
%	   {database_server,start_link,["127.0.0.1",8087]},         % StartFun = {M, F, A}
%	   permanent,                               % Restart  = permanent | transient | temporary
%	   2000,                                    % Shutdown = brutal_kill | int() >= 0 | infinity
%	   worker,                                  % Type     = worker | supervisor
%	   [database_server]                        % Modules  = [Module] | dynamic
%       }

      ]
     }
    };



init([Module]) ->
    {ok,
     {_SupFlags = {simple_one_for_one, ?MAX_RESTART, ?MAX_TIME},
      [
						% TCP Client
       {   undefined,                               % Id       = internal id
	   {Module,start_link,[]},                  % StartFun = {M, F, A}
	   temporary,                               % Restart  = permanent | transient | temporary
	   2000,                                    % Shutdown = brutal_kill | int() >= 0 | infinity
	   worker,                                  % Type     = worker | supervisor
	   []                                       % Modules  = [Module] | dynamic
       }
      ]
     }
    }.

%%----------------------------------------------------------------------
%% Internal functions
%%----------------------------------------------------------------------
get_app_env(Opt, Default) ->
    case application:get_env(application:get_application(), Opt) of
	{ok, Val} -> Val;
	_ ->
	    case init:get_argument(Opt) of
		[[Val | _]] -> Val;
		error       -> Default
	    end
    end.
