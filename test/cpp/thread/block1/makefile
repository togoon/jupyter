sources := *.cc
main : $(sources)
	g++ -g $(filter %.cc ,$(sources)) -lpthread -o test

clean :
	-rm -f main *.o

