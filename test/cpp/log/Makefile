sources := *.cc
exe := log
main : $(sources)
	g++ -g  $(filter %.cc ,$(sources)) -lpthread -o $(exe)

clean :
	-rm -f main *.o
