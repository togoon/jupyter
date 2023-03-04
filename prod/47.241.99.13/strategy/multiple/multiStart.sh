#!/bin/sh

multiDir=/root/FIL/strategy/multiple

simiDir=/root/FIL/strategy/similarity
cd ${simiDir}

#nohup python3 -u main.py -n similarity -s 18010 -c 19010 -X BTCUSDT -p 10m -w 42 -d 84 -t 90000  >> log.txt 2>&1  &
#nohup python3 -u main.py -n similarity -s 18010 -c 19010 -X ETHUSDT -p 10m -w 42 -d 84 -t 10000  >> log.txt 2>&1  &

# nohup python3 -u test_strategy.py -n testStrategy  -c 29090 -X BTCUSDT -p 10m -w 42 -d 84 -t 1000000  >> log.txt 2>&1  &

let i=1
nohup python3 -u main.py -n testmulti${i} -s 8808 -c 1900${i} -X BTCUSDT -p 10m -w 42 -d 84 -t 1000000  >> ${multiDir}/log${i}.txt 2>&1  &

sleep 2m

let i+=1
nohup python3 -u main.py -n testmulti${i} -s 8808 -c 1900${i} -X ETHUSDT -p 10m -w 44 -d 84 -t 1000000  >> ${multiDir}/log${i}.txt 2>&1  &

sleep 2m

let i+=1
nohup python3 -u main.py -n testmulti${i} -s 8808 -c 1900${i} -X BCHUSDT -p 10m -w 46 -d 84 -t 1000000  >> ${multiDir}/log${i}.txt 2>&1  &

sleep 2m

let i+=1
nohup python3 -u main.py -n testmulti${i} -s 8808 -c 1900${i} -X XRPUSDT -p 10m -w 48 -d 84 -t 1000000  >> ${multiDir}/log${i}.txt 2>&1  &

sleep 2m

let i+=1
nohup python3 -u main.py -n testmulti${i} -s 8808 -c 1900${i} -X EOSUSDT -p 10m -w 50 -d 84 -t 1000000  >> ${multiDir}/log${i}.txt 2>&1  &

sleep 2m

let i+=1
nohup python3 -u main.py -n testmulti${i} -s 8808 -c 1900${i} -X LTCUSDT -p 10m -w 52 -d 84 -t 1000000  >> ${multiDir}/log${i}.txt 2>&1  &

sleep 2m

let i+=1
nohup python3 -u main.py -n testmulti${i} -s 8808 -c 1900${i} -X LTCUSDT -p 10m -w 54 -d 84 -t 1000000  >> ${multiDir}/log${i}.txt 2>&1  &


sleep 2m

let i+=1
nohup python3 -u main.py -n testmulti${i} -s 8808 -c 1900${i} -X TRXUSDT -p 10m -w 56 -d 84 -t 1000000  >> ${multiDir}/log${i}.txt 2>&1  &


sleep 2m

let i+=1
nohup python3 -u main.py -n testmulti${i} -s 8808 -c 1900${i} -X ETCUSDT -p 10m -w 58 -d 84 -t 1000000  >> ${multiDir}/log${i}.txt 2>&1  &


sleep 2m

let i+=1
nohup python3 -u main.py -n testmulti${i} -s 8808 -c 190${i} -X LINKUSDT -p 10m -w 60 -d 84 -t 1000000  >> ${multiDir}/log${i}.txt 2>&1  &


#sleep 2m

#let i+=1
#nohup python3 -u main.py -n testmulti${i} -s 8808 -c 190${i} -X XLMUSDT -p 10m -w 62 -d 84 -t 1000000  >> ${multiDir}/log${i}.txt 2>&1  &


#sleep 2m

#let i+=1
#nohup python3 -u main.py -n testmulti${i} -s 8808 -c 190${i} -X ADAUSDT -p 10m -w 64 -d 84 -t 1000000  >> ${multiDir}/log${i}.txt 2>&1  &



sleep 1m

let i+=1
nohup python3 -u testTrade.py -n testmulti${i} -s 8808 -c 190${i} -X BTCUSDT -p 1m  -t 1000000  >> ${multiDir}/log${i}.txt 2>&1  &



sleep 1m

let i+=1
nohup python3 -u testTrade.py -n testmulti${i} -s 8808 -c 190${i} -X DASHUSDT -p 3m  -t 1000000  >> ${multiDir}/log${i}.txt 2>&1  &


sleep 1m

let i+=1
nohup python3 -u testTrade.py -n testmulti${i} -s 8808 -c 190${i} -X ZECUSDT -p 5m  -t 1000000  >> ${multiDir}/log${i}.txt 2>&1  &


sleep 1m

let i+=1
nohup python3 -u testTrade.py -n testmulti${i} -s 8808 -c 190${i} -X XTZUSDT -p 10m  -t 1000000  >> ${multiDir}/log${i}.txt 2>&1  &


sleep 1m

let i+=1
nohup python3 -u testTrade.py -n testmulti${i} -s 8808 -c 190${i} -X BNBUSDT -p 15m  -t 1000000  >> ${multiDir}/log${i}.txt 2>&1  &



sleep 1m

let i+=1
nohup python3 -u testTrade.py -n testmulti${i} -s 8808 -c 190${i} -X ATOMUSDT -p 30m  -t 1000000  >> ${multiDir}/log${i}.txt 2>&1  &



sleep 1m

let i+=1
nohup python3 -u testTrade.py -n testmulti${i} -s 8808 -c 190${i} -X ONTUSDT -p 1h  -t 1000000  >> ${multiDir}/log${i}.txt 2>&1  &


sleep 1m

let i+=1
nohup python3 -u testTrade.py -n testmulti${i} -s 8808 -c 190${i} -X IOTAUSDT -p 1m  -t 1000000  >> ${multiDir}/log${i}.txt 2>&1  &



sleep 1m

let i+=1
nohup python3 -u testTrade.py -n testmulti${i} -s 8808 -c 190${i} -X BATUSDT -p 3m  -t 1000000  >> ${multiDir}/log${i}.txt 2>&1  &


sleep 1m

let i+=1
nohup python3 -u testTrade.py -n testmulti${i} -s 8808 -c 190${i} -X VETUSDT -p 5m  -t 1000000  >> ${multiDir}/log${i}.txt 2>&1  &

# nohup python3 -u testTrade.py -n testmulti20 -s 8808 -c 19020 -X VETUSDT -p 5m  -t 1000000  >> /root/FIL/strategy/multiple/log20.txt 2>&1  & 


