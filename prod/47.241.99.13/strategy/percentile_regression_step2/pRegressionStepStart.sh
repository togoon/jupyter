#!/bin/sh

curDir=/root/FIL/strategy/percentile_regression_step2
cd ${curDir}


nohup python3 -u main.py -n percentile_regression_step2 -s 8808 -c 29100 -X BTCUSDT -p 30m -w 140 -I 20 -T 10 -t 1000000  >> log.txt 2>&1  &


