sources:=*.cc
exe:=s1
dll:=s1.so
main: $(sources)
	g++ -g  $(filter %.cc ,$(sources)) -lpthread -lsqlite3 -o $(exe)

	# g++ -g -fPIC -shared $(filter %.cc ,$(sources)) -lpthread -lsqlite3 -o $(dll)

clean:
	-rm -f $(exe) *.o
