#!/bin/sh

simiDir=/root/binance/crypto/strategy/similarity/
cd ${simiDir}

#nohup python3 -u main.py -n similarity -s 18010 -c 19010 -X BTCUSDT -p 10m -w 42 -d 84 -t 90000  >> log.txt 2>&1  &
#nohup python3 -u main.py -n similarity -s 18010 -c 19010 -X ETHUSDT -p 10m -w 42 -d 84 -t 10000  >> log.txt 2>&1  &

#nohup python3 -u main.py -n testStrategy -s 8808 -c 29090 -X BTCUSDT -p 10m -w 42 -d 84 -t 1000000  >> log.txt 2>&1  &

# nohup python3 -u test_strategy.py -n testStrategy  -c 29090 -X BTCUSDT -p 10m -w 42 -d 84 -t 1000000  >> log.txt 2>&1  &

nohup python3 -u main.py -n similarity -X BTCUSDT -p 10m -w 42 -d 84 -c binance  >> log.txt 2>&1  &

