sources := *.cc
main : $(sources)
	g++ -g  $(filter %.cc ,$(sources)) -lpthread -o server

clean :
	-rm -f main *.o
