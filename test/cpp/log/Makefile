# sources := *.cc
# exe := log
# main : $(sources)
# 	g++ -g  $(filter %.cc ,$(sources)) -lpthread -o $(exe)

# clean :
# 	-rm -f main *.o

filePath:=$(shell pwd)/$(lastword $(MAKEFILE_LIST))
fileName:=$(lastword $(MAKEFILE_LIST))
foldDir:=$(shell dirname $(filePath))
foldName:=$(lastword $(subst  /, , $(shell pwd) ) )	

all:
	@echo all 
	@echo $(foldDir)
	@echo $(filePath)
	@echo $(fileName)	
	@echo $(shell pwd)	
	@echo $(foldName)	

.PHONY:clean
clean:
	echo $(foldDir)
	echo $(filePath)
	@echo $(fileName)


