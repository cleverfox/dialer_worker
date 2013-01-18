-module(calljob).

-export([run/2]).
-export([work/3]).

run(Jid,Arg) ->
%    io:format("Job run~p~n",[[Jid,Arg]]),
    process_flag(trap_exit,true),
    {ok,spawn_link(?MODULE,work,[Jid,Arg,self()])}.

work(Jid,Arg,Pid) ->
%    io:format("Job xrun~p~n",[[Jid,Arg,Pid]]),
    {grp,Grp}=lists:keyfind(grp,1,Arg),
    {ext,Ext}=lists:keyfind(ext,1,Arg),
    Timeout=case lists:keyfind(timeout,1,Arg) of {timeout, To} -> To; _ -> 30000 end,
    case ami_server:originate(Jid,Grp,Ext,Timeout) of
       {ok, {_Jid,Grp,Ext,Sta,Rea,Res,Time}} ->
           XJob=[ 
               {grp,Grp},
               {ext,Ext},
               {status,Sta},
               {res_txt,Rea},
               {res_num,Res},
               {duration,Time} 
           ],
           %XJob=case Time of
           %    undef -> WJob;
           %    A -> [ WJob | {duration, A } ]
           %end,
           Pid ! {job_complete, Jid, XJob};
       _ -> 
           Pid ! {job_error, Jid, unknown}
    end.

