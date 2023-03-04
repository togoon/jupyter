#!/bin/bash

FILE_PATH=/home/at/data/
FILE_NAME_RFRHO=RFRHO.dat
FILE_NAME_RFRHK=RFRHK.dat
FILE_NAME_RFRFTZ=RFRFTZ.dat
FILE_NAME_RFRMD5=RFRMD5.txt

if [[ -f $FILE_PATH$FILE_NAME_RFRHO ]]; then

    MD5_RFRHO=$(echo `md5sum $FILE_PATH$FILE_NAME_RFRHO`)
    MD5_RFRHO=${MD5_RFRHO:0:32}

    if [[ -z ${MD5_RFRHO} ]]; then

        echo `date "+%Y-%m-%d %H:%M:%S"` "ZeroCurve导入报错:" "RFRHO.dat文件MD5值为空, 无法校验"
    fi
else
    echo `date "+%Y-%m-%d %H:%M:%S"` "ZeroCurve导入报错:" "RFRHO.dat文件不存在, 无法校验">>/home/at/test/log/t2.log
fi

if [[ -f $FILE_PATH$FILE_NAME_RFRHK ]]; then

    MD5_RFRHK=$(echo `md5sum $FILE_PATH$FILE_NAME_RFRHK `)
    MD5_RFRHK=${MD5_RFRHK:0:32}

    if [[ -z ${MD5_RFRHK} ]]; then

        echo `date "+%Y-%m-%d %H:%M:%S"` "ZeroCurve导入报错:" "RFRHK.dat文件MD5值为空, 无法校验"
    fi
else
    echo `date "+%Y-%m-%d %H:%M:%S"` "ZeroCurve导入报错:" "RFRHK.dat文件不存在, 无法校验">>/home/at/test/log/t2.log
fi

if [[ -f $FILE_PATH$FILE_NAME_RFRFTZ ]]; then

    MD5_RFRFTZ=$(echo `md5sum $FILE_PATH$FILE_NAME_RFRFTZ `)
    MD5_RFRFTZ=${MD5_RFRFTZ:0:32}

    if [[ -z ${MD5_RFRFTZ} ]]; then

        echo `date "+%Y-%m-%d %H:%M:%S"` "ZeroCurve导入报错:" "RFRFTZ.dat文件MD5值为空, 无法校验"
    fi
else
    echo `date "+%Y-%m-%d %H:%M:%S"` "ZeroCurve导入报错:" "RFRFTZ.dat文件不存在, 无法校验">>/home/at/test/log/t2.log
fi

# echo '$MD5_RFRHO'  $MD5_RFRHO
# echo '$MD5_RFRHK'  $MD5_RFRHK
# echo '$MD5_RFRFTZ' $MD5_RFRFTZ

if [[ -f $FILE_PATH$FILE_NAME_RFRMD5 ]]; then

    # echo `date "+%Y-%m-%d %H:%M:%S"` "文件存在"

    for i in  `cat $FILE_PATH$FILE_NAME_RFRMD5`
    do  
        if [[ -n $MD5_RFRHO  && $i == $MD5_RFRHO ]]; then
            
            echo '$i == $MD5_RFRHO mktimp'  $i

        elif [[ -n $MD5_RFRHK  && $i == $MD5_RFRHK ]]; then

            echo '$i == $MD5_RFRHK mktimp'  $i

        elif [[ -n $MD5_RFRFTZ  && $i == $MD5_RFRFTZ ]]; then

            echo '$i == $MD5_RFRFTZ mktimp'  $i

        fi
    done
else

    echo `date "+%Y-%m-%d %H:%M:%S"` "ZeroCurve导入报错:" "RFRMD5.txt文件不存在, 无法校验">>/home/at/test/log/t2.log
fi