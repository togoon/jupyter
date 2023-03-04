#!/bin/sh

curDir=/root/binancefuture/crypto/strategy/worth
cd ${curDir}

echo `date +'%Y%m%d %H:%M:%S'` 1. flask run...
#nohup flask run &
nohup /usr/bin/python3 /usr/local/bin/flask --app appReport run  >> log.txt 2>&1  &

sleep 50s
echo `date +'%Y%m%d %H:%M:%S'` 2. curl...
cd ${curDir}
curl -s -o /dev/null  http://localhost:5000/worthpt3

sleep 5s
echo `date +'%Y%m%d %H:%M:%S'` 3. cp ps xargs...
cp ${curDir}/templates/worth.html  ${curDir}/bak/worth_`date "+%Y%m%d"`.html
# cp ${curDir}/templates/worth.html  ${curDir}/page/bak/worth.html


# cd ${curDir}/page
#git config --local user.email "ation126@126.com"
#git config --local user.name "ation126"

# git add .
# git commit -m "worth_`date '+%Y%m%d'`"
# git pull --rebase origin master
# git push -u origin master

cd ${curDir}

sleep 1s
echo `date +'%Y%m%d %H:%M:%S'` 4. The End...
ps aux | grep appReport | grep -v grep | awk '{print $2}'| xargs kill -9

