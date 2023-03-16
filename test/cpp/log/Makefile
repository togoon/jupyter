# sources := *.cc
# exe := log
# main : $(sources)
# 	g++ -g  $(filter %.cc ,$(sources)) -lpthread -o $(exe)

# clean :
# 	-rm -f main *.o


dir2:=$(shell pwd)/$(lastword $(MAKEFILE_LIST))
name:=$(lastword $(MAKEFILE_LIST))
dir=$(shell dirname $(dir2))
mian: @echo $(dir)@echo $(dir2)@echo $(name)
