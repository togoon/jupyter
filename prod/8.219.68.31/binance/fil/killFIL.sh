#！/bin/bash

ps aux | grep realFIL  | grep risk | grep -v grep | awk '{print $2}'| xargs kill -9

