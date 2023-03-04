sources := *.cc
exe := s1
main : $(sources)
	g++ -g  $(filter %.cc ,$(sources)) -lpthread -o $(exe)

clean :
	-rm -f main *.o
