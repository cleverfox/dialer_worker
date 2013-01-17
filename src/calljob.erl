-module(calljob).

-export([run/3]).
-export([work/4]).

run(Jid,Nid,Arg) ->
    io:format("Job run~p~n",[[Jid,Nid,Arg]]),
    process_flag(trap_exit,true),
    {ok,spawn_link(?MODULE,work,[Jid,Nid,Arg,self()])}.

work(Jid,Nid,Arg,Pid) ->
    io:format("Job xrun~p~n",[[Jid,Nid,Arg,Pid]]),
    timer:sleep(8000).

