#!/bin/bash
PIDNAME=server
PIDSTATE=`systemctl status $PIDNAME | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1`
if [ "$PIDSTATE" == "running" ]
        then
            echo "$PIDNAME service is running..." 
        else
            systemctl restart $PIDNAME
fi  