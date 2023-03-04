sources:=*.cc
exe:=cfg
dll:=$(exe).so
main: $(sources)
	g++ -g  $(filter %.cc ,$(sources)) -lpthread  -o $(exe)

	# g++ -g -fPIC -shared $(filter %.cc ,$(sources)) -lpthread  -o $(dll)

clean: 
	-rm -f  $(dll) *.o
