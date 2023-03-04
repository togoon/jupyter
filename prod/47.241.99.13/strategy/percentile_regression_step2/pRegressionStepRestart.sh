#!/bin/sh

curDir=/root/FIL/strategy/percentile_regression_step2
cd ${curDir}

ps aux | grep percentile_regression_step2 | grep -v grep | awk '{print $2}'| xargs kill -9

sleep 1

#nohup python3 -u main.py -n similarity -s 18010 -c 19010 -X BTCUSDT -p 10m -w 42 -d 84 -t 90000  >> log.txt 2>&1  &
#nohup python3 -u main.py -n similarity -s 18010 -c 19010 -X ETHUSDT -p 10m -w 42 -d 84 -t 10000  >> log.txt 2>&1  &

nohup python3 -u main.py -n percentile_regression_step2 -s 8808 -c 29100 -X BTCUSDT -p 30m -w 140 -I 20 -T 10 -t 1000000  >> log.txt 2>&1  &

# nohup python3 -u test_strategy.py -n testStrategy  -c 29090 -X BTCUSDT -p 10m -w 42 -d 84 -t 1000000  >> log.txt 2>&1  &


