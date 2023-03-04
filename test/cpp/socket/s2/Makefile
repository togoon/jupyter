sources := *.cc
main : $(sources)
	g++ -g  $(filter %.cc ,$(sources)) -lpthread -o client

clean :
	-rm -f main *.o

