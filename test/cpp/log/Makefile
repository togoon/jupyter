# sources := *.cc
# exe := log
# main : $(sources)
# 	g++ -g  $(filter %.cc ,$(sources)) -lpthread -o $(exe)

# clean :
# 	-rm -f main *.o

.PHONY:clean
clean:
	dir2:=$(shell pwd)/$(lastword $(MAKEFILE_LIST))
	name:=$(lastword $(MAKEFILE_LIST))
	dir=$(shell dirname $(dir2))
	@echo $(dir)
	@echo $(dir2)
	@echo $(name)


