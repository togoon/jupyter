#!/bin/sh

curDir=/root/FIL/strategy/sr_min
cd ${curDir}

ps aux | grep sr_min | grep -v grep | awk '{print $2}'| xargs kill -9

sleep 1

#nohup python3 -u main.py -n similarity -s 18010 -c 19010 -X BTCUSDT -p 10m -w 42 -d 84 -t 90000  >> log.txt 2>&1  &
#nohup python3 -u main.py -n similarity -s 18010 -c 19010 -X ETHUSDT -p 10m -w 42 -d 84 -t 10000  >> log.txt 2>&1  &

#nohup python3 -u main.py -n pyemd2 -s 8808 -c 29091 -X BTCUSDT -p 10m -w 108 -d 120 -t 1000000  >> log.txt 2>&1  &

# nohup python3 -u test_strategy.py -n testStrategy  -c 29090 -X BTCUSDT -p 10m -w 42 -d 84 -t 1000000  >> log.txt 2>&1  &

#nohup python3 -u main.py -n factorcheck -s 8808 -c 29094 -X BTCUSDT -p 5m -w 40 -I 50 -d 2 -T 0.6 -t 1000000  >> log.txt 2>&1  &

# nohup python3 -u main.py -n factorcheck2 -s 8808 -c 29095 -X BTCUSDT -p 5m -w 40 -I 50 -d 5 -T 0.6 -t 1000000  >> log.txt 2>&1  &

# nohup python3 -u main.py -n logic -s 8808 -c 29096 -X BTCUSDT -p 30m -w 40 -d 120 -T 0.55 -t 1000000  >> log.txt 2>&1  &

# nohup python3 -u main.py -n s_rsrs -s 8808 -c 29097 -X BTCUSDT -p 4h -w 25 -I 90 -d 120 -T 0.6 -t 1000000 >> log.txt 2>&1 & 

# nohup python3 -u main.py -n amihud -s 8808 -c 29098 -X BTCUSDT -p 5m -w 144 -I 25 -d 20 -T 0.8 -H 2.5 -t 1000000 >> log.txt 2>&1 &

nohup python3 -u main.py -n sr_min -s 8808 -c 29099 -X BTCUSDT -p 5m -w 192 -I 10 -d 20 -T 0.88 -H 4.0 -t 1000000 >> log.txt 2>&1 &

