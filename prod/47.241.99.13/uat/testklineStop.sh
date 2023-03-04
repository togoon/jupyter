#!/bin/bash

ps aux | grep testkline | grep 8889 | grep -v grep | awk '{print $2}'| xargs kill -9

#curl -X POST -d '{"method":"cancelSubTimer","params":["testkline1",60000]}' http://127.0.0.1:8889/strategy
#curl -X POST -d '{"method":"cancelSubTimer","params":["testkline2",60000]}' http://127.0.0.1:8889/strategy
