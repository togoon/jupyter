MAIN = xml
CC = g++
CFLAGS = -c -g -Wall
$(MAIN):CXML.o
	$(CC) CXML.o  -o xml -L/opt/ApacheXML/lib -lxerces-c
CXML.o:CXML.cpp
	$(CC)  $(CFLAGS) -pedantic -I/opt/ApacheXML/include  CXML.cpp -DMAIN_TEST  
.PHONY:clean
clean:
	rm CXML.o  $(MAIN) 