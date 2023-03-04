#!/bin/bash

curDir=/root/binance/crypto/strategy/worth
cd ${curDir}

echo `date +'%Y%m%d %H:%M:%S'` 1. updateBalance... >> log.txt
#nohup flask run &
nohup /usr/bin/python3 updateBalance.py -n similarity >> log.txt 2>&1  &

sleep 5s

nohup /usr/bin/python3 updateBalance.py -n similarity_big >> log.txt 2>&1  &

app_time=`date +'%H:%M:%S'`
app_hour=`echo ${app_time}|cut -b 1-2`
app_minute=`echo ${app_time}|cut -b 4-5`
app_sec=`echo ${app_time}|cut -b 7-8`

app_hourmin=${app_hour}${app_minute}
app_hourmin=$(( 10#${app_hourmin} ))
app_hour=$(( 10#${app_hour} ))
app_minute=$(( 10#${app_minute} ))
app_sec=$(( 10#${app_sec} ))

app_date=`date +'%Y%m%d'`
app_date=$(( 10#${app_date} ))

#805 1605 5
if [ ${app_hourmin} -eq 805 ] || [ ${app_hourmin} -eq 1605 ] || [ ${app_hourmin} -eq 5 ]  ; then
    echo `date +'%Y%m%d %H:%M:%S'` 2. worthStart...  >> log.txt
    ./worthStart.sh  >> log.txt 2>&1
fi

echo `date +'%Y%m%d %H:%M:%S'` 3. End ---${app_hourmin}-min-- >> log.txt
