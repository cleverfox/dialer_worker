-module(calljob).

-compile([{parse_transform, lager_transform}]).
-export([run/2]).
-export([work/4]).

run(Jid,Arg) ->
%    io:format("Job run~p~n",[[Jid,Arg]]),
    process_flag(trap_exit,true),
    {ok,spawn_link(?MODULE,work,[Jid,Arg,self(),6])}.

work(Jid,Arg,Pid,Try) ->
    lager:info("Job xrun~p~n",[[Jid,Arg,Pid]]),
    %{grp,Grp}=lists:keyfind(grp,1,Arg),
    {ext,Ext}=lists:keyfind(ext,1,Arg),
    {modemid,MID}=lists:keyfind(modemid,1,Arg),
    Timeout=case lists:keyfind(timeout,1,Arg) of {timeout, To} -> To; _ -> 30000 end,
    CallRes=ami_server:originate(Jid,MID,Ext,Timeout,Arg),
    lager:info("Job res ~p",[CallRes]),
    case CallRes of
        {ok, {_,_,_,res,"Failure","8",_}} when ( Try > 0 ) ->
            [Rnd|_]=binary_to_list(crypto:rand_bytes(1)),
            timer:sleep(1000+erlang:round(Rnd/256*9000)),
            work(Jid,Arg,Pid,Try-1);
        {ok, {Jid,MID,Ext,Sta,Rea,Res,Time,IvrRes}} ->
           XJob=[ 
               {modemid,MID},
               {ext,Ext},
               {status,Sta},
               {res_txt,Rea},
               {res_num,Res},
               {duration,Time},
               {ivrres,IvrRes}
           ],
           %XJob=case Time of
           %    undef -> WJob;
           %    A -> [ WJob | {duration, A } ]
           %end,
           Pid ! {job_complete, Jid, XJob};
       _ -> 
           Pid ! {job_error, Jid, unknown}
    end.

