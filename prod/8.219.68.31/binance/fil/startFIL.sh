#！/bin/bash
#cd /root/FIL/fil
#cd /root/binancefuture/crypto/fil
cd /root/binance/crypto/fil

nohup ./realFIL run -c ./config.json -r ./risk.json >> /root/binance/crypto/logs/screenlog_Fil_bash_0.log 2>&1 & 

# nohup ./FIL run -c ./config.json -r ./risk.json -k ./key.json >> /root/FIL/logs/screenlog_Fil_bash_0.log 2>&1 & 

# nohup ./FIL run -c ./config2.json -r ./risk2.json -k ./key.json >> /root/FIL/logs/screenlog_Fil_bash_2.log 2>&1 & 

# nohup ./FIL run -c ./config.json >> /root/FIL/logs/screenlog_Fil_bash_0.log 2>&1 & 

