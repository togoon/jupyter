sources := *.cc
main : $(sources)
	g++ -g  $(filter %.cc ,$(sources)) -lpthread -o main

clean :
	-rm -f main *.o
