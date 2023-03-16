# sources := *.cc
# exe := log
# main : $(sources)
# 	g++ -g  $(filter %.cc ,$(sources)) -lpthread -o $(exe)

# clean :
# 	-rm -f main *.o

filePath:=$(shell pwd)/$(lastword $(MAKEFILE_LIST))
fileName:=$(lastword $(MAKEFILE_LIST))
foldDir=$(shell dirname $(filePath))

man:
	@echo man 1111
	@echo $(filePath)
	@echo $(fileName)	

all:
	@echo all 2222
	@echo $(foldDir)
	@echo $(filePath)
	@echo $(fileName)	


.PHONY:clean
clean:
	echo $(foldDir)
	echo $(filePath)
	@echo $(fileName)


