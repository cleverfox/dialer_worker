all:
	./rebar compile
run:
	erl -pa ebin -pa deps/epgsql/ebin deps/lager/ebin deps/poolboy/ebin -boot start_sasl -sname e1 -config dialer.config -s lager start -s dialer_app start

