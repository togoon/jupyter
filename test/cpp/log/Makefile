# sources := *.cc
# exe := log
# main : $(sources)
# 	g++ -g  $(filter %.cc ,$(sources)) -lpthread -o $(exe)

# clean :
# 	-rm -f main *.o

filepath:=$(shell pwd)/$(lastword $(MAKEFILE_LIST))
name:=$(lastword $(MAKEFILE_LIST))
dir=$(shell dirname $(filepath))

.PHONY:clean
clean:

	echo $(dir)
	echo $(filepath)
	@echo $(name)


