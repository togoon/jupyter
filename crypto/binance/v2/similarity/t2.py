import os
import time

ts = f'{int(time.time())-12 }999'
# print( f'{ts}' ) 

cmd = f' echo -n "recvWindow=5000&timestamp={ts}" | openssl dgst -sha256 -hmac "4f58b518cecdfe9c574cd2aa9cbbea429796673d6226424bdda1f0155cd78876" '
# print( cmd ) 

# echo -n "recvWindow=5000&timestamp=1661168970999" | openssl dgst -sha256 -hmac "4f58b518cecdfe9c574cd2aa9cbbea429796673d6226424bdda1f0155cd78876"

# curl -H "X-MBX-APIKEY: dbefbc809e3e83c283a984c3a1459732ea7db1360ca80c5c2c8867408d28cc83" -X POST 'https://fapi.binance.com/fapi/v1/order?symbol=BTCUSDT&side=BUY&type=LIMIT&quantity=1&price=9000&timeInForce=GTC&recvWindow=5000&timestamp=1591702613943&signature= 3c661234138461fcc7a7d8746c6558c9842d4e10870d2ecbedf7777cad694af9'

# ret = os.system( f' echo -n "recvWindow=5000&timestamp={int(time.time())-10 }999" | openssl dgst -sha256 -hmac "4f58b518cecdfe9c574cd2aa9cbbea429796673d6226424bdda1f0155cd78876" ' )

stdin = os.popen(cmd).read()
print(f'{stdin}')
sign = stdin[9:-1]
# print(f'{sign}')

cmd2 = f'curl -H "X-MBX-APIKEY: fcc2838327a124367acd634323b93b1fb53d6fc66e84d679169a78adcaf1bf3e" -XGET "http://testnet.binancefuture.com/fapi/v2/balance?recvWindow=5000&timestamp={ts}&signature={sign}" '
print(f'{cmd2}')

ret = os.popen(cmd2).read()
print(f'{ret}')
