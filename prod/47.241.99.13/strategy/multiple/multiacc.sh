#!/bin/bash



#创建主账户
curl -X POST -d '{"method":"createMainAccount","params":["multiaccount",3,0]}' http://127.0.0.1:8808/strategy

#充值
curl -X POST -d '{"method":"recharge","params":["multiaccount","USDT","100000000.0"]}' http://127.0.0.1:8808/strategy

let port=0

for((i=1;i<=5;i++));  
do
    #创建子账户
    curl -X POST -d '{"method":"createSubAccount","params":["submulti'${i}'",3,"10000000.0"]}' http://127.0.0.1:8808/strategy

    for((j=1;j<=10;j++));  
    do    
        let port+=1

        # if [ $i -eq 1 -a $j -eq 1 ]
        # then
        #     continue
        # fi


        #创建策略 9090
        curl -X POST -d '{"method":"hello","params":["testmulti'${port}'","multiaccount","submulti'${i}'","127.0.0.1", '$[${port}+19000]' ]}' http://127.0.0.1:8808/strategy

        #策略划转现货至U本位合约
        curl -X POST -d '{"method":"accountTransfer","params":["multiaccount","submulti'${i}'","testmulti'${port}'","USDT","1000000.0",0]}' http://127.0.0.1:8808/strategy

    done
done








