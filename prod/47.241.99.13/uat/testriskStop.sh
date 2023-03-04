#!/bin/bash

ps aux | grep testrisk | grep 8889 | grep -v grep | awk '{print $2}'| xargs kill -9

#curl -X POST -d '{"method":"cancelSubTimer","params":["testrisk1",60000]}' http://127.0.0.1:8889/strategy
#curl -X POST -d '{"method":"cancelSubTimer","params":["testrisk2",60000]}' http://127.0.0.1:8889/strategy
