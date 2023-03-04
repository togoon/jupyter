#!/bin/sh

curDir=/root/FIL/strategy/modifiedmom
cd ${curDir}

#nohup python3 -u main.py -n similarity -s 18010 -c 19010 -X BTCUSDT -p 10m -w 42 -d 84 -t 90000  >> log.txt 2>&1  &
#nohup python3 -u main.py -n similarity -s 18010 -c 19010 -X ETHUSDT -p 10m -w 42 -d 84 -t 10000  >> log.txt 2>&1  &

#nohup python3 -u main.py -n pyemd2 -s 8808 -c 29091 -X BTCUSDT -p 10m -w 108 -d 120 -t 1000000  >> log.txt 2>&1  &

# nohup python3 -u test_strategy.py -n testStrategy  -c 29090 -X BTCUSDT -p 10m -w 42 -d 84 -t 1000000  >> log.txt 2>&1  &

nohup python3 -u main.py -n modifiedmom -s 8808 -c 29093 -X BTCUSDT -p 10m -w 71 -d 3 -T 0 -t 1000000  >> log.txt 2>&1  &

