all:
	./rebar compile
run:
	rlwrap --always-readline erl -pa ebin -pa deps/epgsql/ebin deps/lager/ebin deps/poolboy/ebin -boot start_sasl -sname e1 -config dialer.config -s lager start -s dialer_app start
deploy:
	erl -detached -pa ebin -pa deps/epgsql/ebin deps/lager/ebin deps/poolboy/ebin deps/goldrush/ebin -boot start_sasl -noshell -noinput -name dialer@`hostname` -config dialer.config -s lager start -s dialer_app start
attach:
	rlwrap --always-readline erl -name dialerrcon@`hostname` -remsh dialer@`hostname`
stop:
	echo 'halt().' | erl -name dialerrcon@`hostname` -remsh dialer@`hostname`
redeploy:
	killall beam.smp || sleep 1
	sleep 3
	erl -detached -pa ebin -pa deps/epgsql/ebin deps/lager/ebin deps/poolboy/ebin deps/goldrush/ebin -boot start_sasl -noshell -noinput -name dialer@`hostname` -config dialer.config -s lager start -s dialer_app start

