sources:=*.cc
exe:=u2
dll:=$(exe).so
main: $(sources)

	g++ -g  $(filter %.cc ,$(sources)) -lpthread  -I/usr/include/lua5.3 -o $(exe)
	
	# gcc -g -fPIC -shared $(filter %.cc ,$(sources)) -lpthread  -I/usr/include/lua5.3 -o $(dll)
	
	# g++ -g  $(filter %.cc ,$(sources)) -lpthread  -o $(exe)

	# g++ -g -fPIC -shared $(filter %.cc ,$(sources)) -lpthread  -o $(dll)

clean: 
	-rm -f  $(dll) *.o
