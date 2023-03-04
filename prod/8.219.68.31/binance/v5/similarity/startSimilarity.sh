#!/bin/sh

#simiDir=/root/FIL/v5/similarity
simiDir=/root/binance/crypto/v5/similarity
cd ${simiDir}

nohup python3 -u main.py -n similarity -s 18889 -c 32001 -X BTCUSDT -p 10m -w 42 -d 84 -t 1000 -r 0.5 >> log.txt 2>&1  &

# nohup python3 -u main.py -n testrisk1 -s 8889 -c 39291 -X BTCUSDT -p 10m -w 42 -d 84 -t 1000000  >> log.txt 2>&1  &

#nohup python3 -u main.py -n similarity -s 18010 -c 19010 -X BTCUSDT -p 10m -w 42 -d 84 -t 90000  >> log.txt 2>&1  &
#nohup python3 -u main.py -n similarity -s 18010 -c 19010 -X ETHUSDT -p 10m -w 42 -d 84 -t 10000  >> log.txt 2>&1  &

# nohup python3 -u main.py -n testStrategy -s 8808 -c 29090 -X BTCUSDT -p 10m -w 42 -d 84 -t 1000000  >> log.txt 2>&1  &

# nohup python3 -u test_strategy.py -n testStrategy  -c 29090 -X BTCUSDT -p 10m -w 42 -d 84 -t 1000000  >> log.txt 2>&1  &


