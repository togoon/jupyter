#!/bin/bash

curDir=/root/FIL/strategy/flask/worth
cd ${curDir}

echo `date +'%Y%m%d %H:%M:%S'` 1. flask run... 
#nohup flask run &
nohup /usr/bin/python3 /usr/local/bin/flask run -p 5555 & 
# nohup /usr/bin/python3 /usr/local/bin/flask run  >> ${curDir}/log.txt 2>&1  & 

echo `date +'%Y%m%d %H:%M:%S'` 2. curl...$?... 
sleep 3m
cd ${curDir}
curl -s -o /dev/null  http://localhost:5000/worthpt 

echo `date +'%Y%m%d %H:%M:%S'` 3. cp ps xargs...$?... 
sleep 2m
cp ${curDir}/templates/worth.html  ${curDir}/bak/worth_`date "+%Y%m%d"`.html 
cp ${curDir}/templates/worth.html  ${curDir}/page/bak/worth.html 

echo `date +'%Y%m%d %H:%M:%S'` 4. log.md... 

logFile=${curDir}/page/bak/log.md
echo `date +'# %Y%m%d %H:%M:%S'` > ${logFile}
echo >> ${logFile}

for dir_name in `ls /root/FIL/strategy/`
do
    ignoreDir="flask multiple Panel_mom2"
    if [[ "${ignoreDir[@]}"  =~ $dir_name ]]; then
        # echo "$dir_name 存在"
        continue
    fi

    cur_dir="/root/FIL/strategy/$dir_name"
    if [ -d $cur_dir ]
    then
        echo "##" ${cur_dir}/log.txt ----- ----- >> ${logFile} 2>&1
        echo >> ${logFile} 2>&1
        tail -n 30 ${cur_dir}/log.txt >> ${logFile} 2>&1
        echo >> ${logFile} 2>&1
        echo >> ${logFile} 2>&1
    fi
done


cd ${curDir}/page
#git config --local user.email "ation126@126.com"
#git config --local user.name "ation126"

git add .
git commit -m "worth_`date '+%Y%m%d'`"
git pull --rebase origin master
git push -u origin master

cd ${curDir}

sleep 10s
echo `date +'%Y%m%d %H:%M:%S'` 5. The End... 
ps aux | grep flask | grep -v grep | awk '{print $2}'| xargs kill -9

