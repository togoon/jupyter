#!/bin/sh

curDir=/workspaces/jupyter
# curDir=/home/at/test/jupyter
cd ${curDir}

locHouradj=8 # 0 8
# timedatectl set-timezone Asia/Shanghai

echo `date -d "+${locHouradj} hour" +'%Y-%m-%d %H:%M:%S'`  # >> ${curDir}/tmp/test.log 2>&1 

# export PS1="\[\e[1;36m\]\u\[\e[1;30m\]@\[\e[0;37m\]\W\[\e[1;32m\]\\$\[\e[0m\]"
#cp ${curDir}/.vimrc ~/


git add .   
git commit -m "`date -d "+${locHouradj} hour" '+%Y-%m-%d %H:%M:%S'`"  

git pull --rebase origin main  # master > main
git push -u origin main  #  >> ${curDir}/tmp/test.log 2>&1 

datestr=`date -d "+${locHouradj} hour" '+%Y%m%d'`
timestr=`date -d "+${locHouradj} hour" '+%H%M%S'`
app_time=`date -d "+${locHouradj} hour" '+%H:%M:%S'`
# app_hour=`echo ${app_time} | cut -b 1-2`
# app_minute=`echo ${app_time} | cut -b 4-5`
# app_sec=`echo ${app_time} | cut -b 7-8`

app_hour=`date -d "+${locHouradj} hour" '+%_H'`
app_minute=`date -d "+${locHouradj} hour" '+%_M'`
app_sec=`date -d "+${locHouradj} hour" '+%_S'`
app_hourmin=`date -d "+${locHouradj} hour" '+%_H%M'`

# app_hourmin=${app_hour}${app_minute}
# app_hourmin=$(( 10#${app_hourmin} ))
# app_hour=$(( 10#${app_hour} ))
# app_minute=$(( 10#${app_minute} ))
# app_sec=$(( 10#${app_sec} ))

app_date=`date -d "+${locHouradj} hour" '+%Y%m%d'`
# app_date=$(( 10#${app_date} ))

# echo 4. ${app_hour} ${app_minute} ${app_date}  >> ${curDir}/tmp/test.log 2>&1 

if [ ${app_hour} -eq 4 -o ${app_hour} -eq 8 -o ${app_hour} -eq 10 -o ${app_hour} -eq 12 -o ${app_hour} -eq 14 -o ${app_hour} -eq 16 -o ${app_hour} -eq 18 -o ${app_hour} -eq 20 -o ${app_hour} -eq 22 -o ${app_hour} -eq 0 ] && [ ${app_minute} -eq 0 ]
then
    cd ${curDir}/..
    zip -r jupyter_`date -d "+${locHouradj} hour" '+%Y%m%d'`.zip jupyter -x='jupyter/.git/*'  #
    aliyunpan u ${curDir}_`date -d "+${locHouradj} hour" '+%Y%m%d'`.zip /backup/jupyter/ --ow
	sleep 5
    rm -rf ${curDir}_*.zip
fi


