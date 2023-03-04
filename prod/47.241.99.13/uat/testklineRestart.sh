#!/bin/sh

curDir=/root/FIL/uat
cd ${curDir}

ps aux | grep testkline | grep 8889 | grep -v grep | awk '{print $2}'| xargs kill -9

curl -X POST -d '{"method":"cancelSubTimer","params":["testkline1",60000]}' http://127.0.0.1:8889/strategy

curl -X POST -d '{"method":"cancelSubTimer","params":["testkline2",60000]}' http://127.0.0.1:8889/strategy

sleep 1

nohup python3 -u main_kline1.py -n testkline1 -s 8889 -c 39193 -X BTCUSDT -p 3m -w 40 -d 3 -T 0.5 -t 7500  >> log_kline1.log 2>&1 &

nohup python3 -u main_kline2.py -n testkline2 -s 8889 -c 39194 -X BTCUSDT -p 3m -w 40 -d 3 -T 0.5 -t 7500  >> log_kline2.log 2>&1 &


# sleep 1

# nohup python3 -u main_kline7.py -n testkline7 -s 8889 -c 39094 -X BTCUSDT -p 3m -w 40 -d 3 -T 0.5 -t 10000  >> log_kline7.log 2>&1 &

# nohup python3 -u main_kline8.py -n testkline8 -s 8889 -c 39095 -X BTCUSDT -p 3m -w 40 -d 3 -T 0.5 -t 5000  >> log_kline7.log 2>&1 &

#nohup python3 -u main.py -n similarity -s 18010 -c 19010 -X BTCUSDT -p 10m -w 42 -d 84 -t 90000  >> log.txt 2>&1  &
#nohup python3 -u main.py -n similarity -s 18010 -c 19010 -X ETHUSDT -p 10m -w 42 -d 84 -t 10000  >> log.txt 2>&1  &

#nohup python3 -u main.py -n pyemd2 -s 8808 -c 29091 -X BTCUSDT -p 10m -w 108 -d 120 -t 1000000  >> log.txt 2>&1  &

# nohup python3 -u test_strategy.py -n testStrategy  -c 29090 -X BTCUSDT -p 10m -w 42 -d 84 -t 1000000  >> log.txt 2>&1  &

#nohup python3 -u main.py -n factorcheck -s 8808 -c 29094 -X BTCUSDT -p 5m -w 40 -I 50 -d 2 -T 0.6 -t 1000000  >> log.txt 2>&1  &

# nohup python3 -u main.py -n factorcheck2 -s 8808 -c 29095 -X BTCUSDT -p 5m -w 40 -I 50 -d 5 -T 0.6 -t 1000000  >> log.txt 2>&1  &

# nohup python3 -u main.py -n logic -s 8808 -c 29096 -X BTCUSDT -p 30m -w 40 -d 120 -T 0.55 -t 1000000  >> log.txt 2>&1  &
