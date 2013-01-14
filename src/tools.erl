%%%-------------------------------------------------------------------
%%% @author Vladimir Goncharov <viruzzz@lnb.local>
%%% @copyright (C) 2012, Vladimir Goncharov
%%% @doc
%%%
%%% @end
%%% Created :  8 Aug 2012 by Vladimir Goncharov <viruzzz@lnb.local>
%%%-------------------------------------------------------------------
-module(tools).

%% API
-export([decode_term/1,encode_term/2,encode_term/3,data_decode/1]).

%%%===================================================================
%%% API
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------

%%%===================================================================
%%% Internal functions
%%%===================================================================

data_decode(Object) ->
    case riakc_obj:get_content_type(Object) of
        <<"application/x-erlang-term">>  ->
	    try
		{ok, term, binary_to_term(riakc_obj:get_value(Object))}
	    catch
		_:Reason ->
		    {error, Reason}
	    end;
        Ctype ->
	    {ok, Ctype, riakc_obj:get_value(Object)}
    end.

decode_term(Object) ->
    case riakc_obj:get_content_type(Object) of
        <<"application/x-erlang-term">>  ->
	    try
		{ok, binary_to_term(riakc_obj:get_value(Object))}
	    catch
		_:Reason ->
		    {error, Reason}
	    end;
        "application/x-erlang-term"  ->
	    try
		{ok, binary_to_term(riakc_obj:get_value(Object))}
	    catch
		_:Reason ->
		    {error, Reason}
	    end;
        Ctype ->
	    {error, {unknown_ctype, Ctype}}
    end.

encode_term(Object, Term) ->
    riakc_obj:update_value(Object, term_to_binary(Term, [compressed]),
			   <<"application/x-erlang-term">>).

encode_term(Bucket, Key, Term) ->
    riakc_obj:new(Bucket, Key, term_to_binary(Term, [compressed]),
		  <<"application/x-erlang-term">>).

