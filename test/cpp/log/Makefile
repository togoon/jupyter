sources := *.cc
exe :=$(lastword $(subst  /, , $(shell pwd) ) )	
main : $(sources)
	g++ -g  $(filter %.cc ,$(sources)) -lpthread -o $(exe)

clean :
	-rm -f main *.o


