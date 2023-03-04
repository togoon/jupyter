sources:=*.cc
exe:=daemon
dll:=$(exe).so
main: $(sources)
	
	g++ -g  $(filter %.cc ,$(sources)) -lpthread  -o $(exe)

	# g++ -g -fPIC -shared $(filter %.cc ,$(sources)) -lpthread  -o $(dll)

	# g++ -g  $(filter %.cc ,$(sources)) -lpthread  -I/usr/include/lua5.3 -o $(exe)
	
	# gcc -g -fPIC -shared $(filter %.cc ,$(sources)) -lpthread  -I/usr/include/lua5.3 -o $(dll)

clean: 
	-rm -f  $(exe) *.o
