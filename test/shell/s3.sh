#!/bin/bash
md5=(00205d1c a3da1677 1 f6d12dd 890684b)
for i in ${md5[*]}
do
   for num in $(seq θ 32767)
   do
     result=$(echo $num | md5sum | cut -c 1-8 )
     if [ $result == $i ];then
        echo "$i : $num" >> a.Log
     fi
   done
done