#!/bin/bash

# ps aux | grep similarity | grep 32001 | grep 8889 | grep -v grep | awk '{print $2}'| xargs kill -9

ps aux | grep 18889 | grep similarity | grep 32001 | grep -v grep | awk '{print $2}'| xargs kill -9

