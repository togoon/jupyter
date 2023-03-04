#!/bin/sh

curDir=/root/FIL/strategy/flask/worth
cd ${curDir}

echo `date +'%Y%m%d %H:%M:%S'` 1. flask run... 
#nohup flask run &
nohup /usr/bin/python3 /root/FIL/strategy/flask/worth/appReport.py & 

sleep 3m
echo `date +'%Y%m%d %H:%M:%S'` 2. curl... 
cd ${curDir}
curl -s -o /dev/null  http://localhost:5555/worthpt 

sleep 2m
echo `date +'%Y%m%d %H:%M:%S'` 3. cp ps xargs... 
cp ${curDir}/templates/worth.html  ${curDir}/bak/worth_`date "+%Y%m%d"`.html 
cp ${curDir}/templates/worth.html  ${curDir}/page/bak/report.html 


cd ${curDir}/page
#git config --local user.email "ation126@126.com"
#git config --local user.name "ation126"

git add .
git commit -m "worth_`date '+%Y%m%d'`"
git pull --rebase origin master
git push -u origin master

cd ${curDir}

sleep 10s
echo `date +'%Y%m%d %H:%M:%S'` 4. The End... 
ps aux | grep flask | grep -v grep | awk '{print $2}'| xargs kill -9

