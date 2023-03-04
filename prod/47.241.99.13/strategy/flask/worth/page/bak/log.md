# 20230120 08:16:01

## /root/FIL/strategy/amihud/log.txt ----- -----

--handleKline--:  version='2.0.0', self.name='amihud', self.symbol='BTCUSDT', interval='5m', intervalSec=300, wid=144, thd=0.8, self.sign=-1, self.total=993672.4896432, self.flagDict['side']='sell', self.tradeCount=2, self.count=15482
self.closeSec=1674173399, self.tradeDate='20230120', self.openTime='080500', self.closeTime='080959', self.symbol='BTCUSDT', self.open=21083.2, self.close=21056.8, self.high=21095.2, self.low=21056.8, self.vol=1093.351, self.amt=23048909.1558 
127.0.0.1 - - [20/Jan/2023 08:10:01] "POST / HTTP/1.1" 200 -
2023-01-20 08:10:01,513:INFO:amihud:main.py:172:handleKline:200676: ukdf.iloc[-5:,:] :
     tradeDate openTime closeTime  ...  value_mean  value_std  signal
5853  20230120   074500    074959  ...         0.0        0.0       0
5854  20230120   075000    075459  ...         0.0        0.0       0
5855  20230120   075500    075959  ...         0.0        0.0       0
5856  20230120   080000    080459  ...         0.0        0.0       0
5857  20230120   080500    080959  ...         0.0        0.0       0

[5 rows x 18 columns]
2023-01-20 08:10:01,513:INFO:amihud:main.py:175:handleKline:200676: self.closeSec=1674173399, self.tradeDate='20230120', self.openTime='080500', self.closeTime='080959',self.symbol='BTCUSDT',self.open=21083.2, self.close=21056.8, self.high=21095.2, self.low=21056.8, self.vol=1093.351, self.amt=23048909.1558, ukdf['pct'].iloc[-1]=-0.001224 , ukdf['amount'].iloc[-1]=23048909.1558, ukdf['indicator'].iloc[-1]=0.0, ukdf['index'].iloc[-1]=5857, value=0.0, value_mean=0.0, signal=0, value_std=0.0 
queryPositions: self.symbol='BTCUSDT', positions=PositionsReturn{'result': [PositionType{'sysID': SystemID{'mainID': '', 'subID': '', 'strategyID': ''}, 'symbol': 'BTCUSDT', 'positionAmount': '60.176', 'enterprice': '16529.3', 'countrevence': '0', 'unrealprofit': '-272504.51159463024', 'marginmodel': 0, 'isolatedmargin': '0', 'positionside': 'short', 'markprice': '21057.75838199', 'status': 'none', 'closeprice': '0', 'closeamount': '0', 'opentime': 0, 'closetime': 0, 'type': 'AssetType_ucontract'}]}
type(curSign)=<class 'int'>, curSign=0, self.sign=-1
127.0.0.1 - - [20/Jan/2023 08:15:00] "POST / HTTP/1.1" 200 -
--handleKline--:  version='2.0.0', self.name='amihud', self.symbol='BTCUSDT', interval='5m', intervalSec=300, wid=144, thd=0.8, self.sign=-1, self.total=993672.4896432, self.flagDict['side']='sell', self.tradeCount=2, self.count=15483
self.closeSec=1674173699, self.tradeDate='20230120', self.openTime='081000', self.closeTime='081459', self.symbol='BTCUSDT', self.open=21056.8, self.close=21056.7, self.high=21076.3, self.low=21048.9, self.vol=1055.965, self.amt=22238675.4343 
2023-01-20 08:15:00,765:INFO:amihud:main.py:172:handleKline:200676: ukdf.iloc[-5:,:] :
     tradeDate openTime closeTime  ...  value_mean  value_std  signal
5854  20230120   075000    075459  ...         0.0        0.0       0
5855  20230120   075500    075959  ...         0.0        0.0       0
5856  20230120   080000    080459  ...         0.0        0.0       0
5857  20230120   080500    080959  ...         0.0        0.0       0
5858  20230120   081000    081459  ...         0.0        0.0       0

[5 rows x 18 columns]
2023-01-20 08:15:00,767:INFO:amihud:main.py:175:handleKline:200676: self.closeSec=1674173699, self.tradeDate='20230120', self.openTime='081000', self.closeTime='081459',self.symbol='BTCUSDT',self.open=21056.8, self.close=21056.7, self.high=21076.3, self.low=21048.9, self.vol=1055.965, self.amt=22238675.4343, ukdf['pct'].iloc[-1]=-5e-06 , ukdf['amount'].iloc[-1]=22238675.4343, ukdf['indicator'].iloc[-1]=0.0, ukdf['index'].iloc[-1]=5858, value=0.0, value_mean=0.0, signal=0, value_std=0.0 
queryPositions: self.symbol='BTCUSDT', positions=PositionsReturn{'result': [PositionType{'sysID': SystemID{'mainID': '', 'subID': '', 'strategyID': ''}, 'symbol': 'BTCUSDT', 'positionAmount': '60.176', 'enterprice': '16529.3', 'countrevence': '0', 'unrealprofit': '-272503.30156238352', 'marginmodel': 0, 'isolatedmargin': '0', 'positionside': 'short', 'markprice': '21057.73827377', 'status': 'none', 'closeprice': '0', 'closeamount': '0', 'opentime': 0, 'closetime': 0, 'type': 'AssetType_ucontract'}]}
type(curSign)=<class 'int'>, curSign=0, self.sign=-1


## /root/FIL/strategy/factorcheck/log.txt ----- -----


self.closeSec=1674173399, self.tradeDate='20230120', self.openTime='080500', self.closeTime='080959', self.symbol='BTCUSDT', self.open=21083.2, self.close=21056.8, self.high=21095.2, self.low=21056.8 
2023-01-20 08:10:01,436:INFO:factorcheck2:main.py:126:handleKline:185239: self.closeSec=1674173399, self.tradeDate='20230120', self.openTime='080500', self.closeTime='080959',self.symbol='BTCUSDT',self.open=21083.2, self.close=21056.8, self.high=21095.2, self.low=21056.8   
127.0.0.1 - - [20/Jan/2023 08:10:01] "POST / HTTP/1.1" 200 -
2023-01-20 08:10:01,475:INFO:factorcheck2:main.py:127:handleKline:185239: ukdf.iloc[-5:,:] :
     tradeDate openTime closeTime    closeSec  ...      low       pct  index  idx
1533  20230120   074500    074959  1674172199  ...  21055.1 -0.000385   1533    3
1534  20230120   075000    075459  1674172499  ...  21056.7  0.000969   1534    4
1535  20230120   075500    075959  1674172799  ...  21068.1 -0.000465   1535    5
1536  20230120   080000    080459  1674173099  ...  21053.5  0.000679   1536    0
1537  20230120   080500    080959  1674173399  ...  21056.8 -0.001224   1537    1

[5 rows x 11 columns]
2023-01-20 08:10:01,475:INFO:factorcheck2:main.py:128:handleKline:185239: self.flagDict={'side': 'buy', 'posBuy': 0, 'posSell': 0, 'isNewDay': True, 'isOpenBuy': True, 'isOpenSell': False, 'isCloseBuy': False, 'isCloseSell': False, 'isOpen': True, 'isClose': False, 'isTrig': True}
127.0.0.1 - - [20/Jan/2023 08:15:00] "POST / HTTP/1.1" 200 -

--handleKline--:  version='2.0.6', self.name='factorcheck2', self.symbol='BTCUSDT', interval='5m', intervalSec=300, wid=40, wid2=50, thd=0.6, self.factorCnt=14, self.factor=0.49336998526964926, self.count=16049 

self.closeSec=1674173699, self.tradeDate='20230120', self.openTime='081000', self.closeTime='081459', self.symbol='BTCUSDT', self.open=21056.8, self.close=21056.7, self.high=21076.3, self.low=21048.9 
2023-01-20 08:15:00,691:INFO:factorcheck2:main.py:126:handleKline:185239: self.closeSec=1674173699, self.tradeDate='20230120', self.openTime='081000', self.closeTime='081459',self.symbol='BTCUSDT',self.open=21056.8, self.close=21056.7, self.high=21076.3, self.low=21048.9   
2023-01-20 08:15:00,753:INFO:factorcheck2:main.py:127:handleKline:185239: ukdf.iloc[-5:,:] :
     tradeDate openTime closeTime    closeSec  ...      low       pct  index  idx
1534  20230120   075000    075459  1674172499  ...  21056.7  0.000969   1534    4
1535  20230120   075500    075959  1674172799  ...  21068.1 -0.000465   1535    5
1536  20230120   080000    080459  1674173099  ...  21053.5  0.000679   1536    0
1537  20230120   080500    080959  1674173399  ...  21056.8 -0.001224   1537    1
1538  20230120   081000    081459  1674173699  ...  21048.9 -0.000005   1538    2

[5 rows x 11 columns]
2023-01-20 08:15:00,754:INFO:factorcheck2:main.py:128:handleKline:185239: self.flagDict={'side': 'buy', 'posBuy': 0, 'posSell': 0, 'isNewDay': True, 'isOpenBuy': True, 'isOpenSell': False, 'isCloseBuy': False, 'isCloseSell': False, 'isOpen': True, 'isClose': False, 'isTrig': True}


## /root/FIL/strategy/logic/log.txt ----- -----

2023-01-20 08:00:33,048:DEBUG:logic:main.py:463:getModel:885513: df_s.iloc[-5:,:] :
          date closeTime     open  ...    alpha58   alpha67   alpha72
5770  20230120    052959  21099.0  ...  50.833333  0.521416  0.376548
5771  20230120    055959  21040.9  ...  50.416667  0.496342  0.383761
5772  20230120    062959  20929.8  ...  50.833333  0.509727  0.382694
5773  20230120    065959  20991.7  ...  50.833333  0.524522  0.372671
5774  20230120    072959  21062.4  ...  50.416667  0.523816  0.363712

[5 rows x 33 columns]
0.5452865064695009
acc is : 0.5452865064695009
2023-01-20 08:00:33,225:INFO:logic:main.py:468:getModel:885513: df_pred.iloc[-5:,:] :
     pred    prob_0    prob_1  actual  ...       nav  sign  cost_        bm
536     0  0.514335  0.485665       0  ...  1.057183   1.0    0.0  1.235896
537     1  0.475042  0.524958       1  ...  1.060300   1.0    0.0  1.239539
538     0  0.509583  0.490417       1  ...  1.063876   1.0    0.0  1.243720
539     0  0.518321  0.481679       0  ...  1.063719   1.0    0.0  1.243537
540     0  0.509246  0.490754       1  ...  1.064174   1.0    0.0  1.244068

[5 rows x 10 columns]
2023-01-20 08:00:33,256:INFO:logic:main.py:478:getModel:885513: df_panel.iloc[-5:,:] :
    pred    prob_0    prob_1  actual  ...       nav  sign  cost_        bm
45     0  0.514302  0.485698       0  ...  1.057183   1.0    0.0  1.231823
46     1  0.475031  0.524969       1  ...  1.060300   1.0    0.0  1.240286
47     0  0.509900  0.490100       1  ...  1.063876   1.0    0.0  1.244080
48     0  0.518321  0.481679       0  ...  1.063719   1.0    0.0  1.243537
49     0  0.509246  0.490754       1  ...  1.064174   1.0    0.0  1.244068

[5 rows x 10 columns]
queryPositions: self.symbol='BTCUSDT', positions=PositionsReturn{'result': [PositionType{'sysID': SystemID{'mainID': '', 'subID': '', 'strategyID': ''}, 'symbol': 'BTCUSDT', 'positionAmount': '33.709', 'enterprice': '20883.4', 'countrevence': '0', 'unrealprofit': '6465.3862', 'marginmodel': 0, 'isolatedmargin': '0', 'positionside': 'long', 'markprice': '21075.2', 'status': 'none', 'closeprice': '0', 'closeamount': '0', 'opentime': 0, 'closetime': 0, 'type': 'AssetType_ucontract'}]}


## /root/FIL/strategy/modifiedmom/log.txt ----- -----

622  20230120   074000    074959  1674172199  21055.8  21057.7  0.000090
2023-01-20 07:50:00,816:INFO:modifiedmom:main.py:146:handleKline:185213: self.flagDict={'side': 'buy', 'posBuy': 0, 'posSell': 0, 'isNewDay': True, 'isOpenBuy': False, 'isOpenSell': False, 'isCloseBuy': True, 'isCloseSell': True, 'isOpen': False, 'isClose': True, 'isTrig': False}

--handleKline--:  self.name='modifiedmom', self.symbol='BTCUSDT', interval='10m', intervalSec=600, self.count=8023 

self.closeSec=1674172799, self.tradeDate='20230120', self.openTime='075000', self.closeTime='075959', self.symbol='BTCUSDT', self.open='21056.7', self.close='21068.3'
2023-01-20 08:00:01,515:INFO:modifiedmom:main.py:144:handleKline:185213: self.closeSec=1674172799, self.tradeDate='20230120', self.openTime='075000', self.closeTime='075959',self.symbol='BTCUSDT',self.open='21056.7', self.close='21068.3'
127.0.0.1 - - [20/Jan/2023 08:00:01] "POST / HTTP/1.1" 200 -
2023-01-20 08:00:01,536:INFO:modifiedmom:main.py:145:handleKline:185213: ukdf.iloc[-5:,:] :
    tradeDate openTime closeTime    closeSec     open    close       pct
619  20230120   071000    071959  1674170399  21037.4    21025 -0.000594
620  20230120   072000    072959  1674170999  21024.8  21059.3  0.001631
621  20230120   073000    073959  1674171599  21059.3  21055.8 -0.000166
622  20230120   074000    074959  1674172199  21055.8  21057.7  0.000090
623  20230120   075000    075959  1674172799  21056.7  21068.3  0.000503
2023-01-20 08:00:01,536:INFO:modifiedmom:main.py:146:handleKline:185213: self.flagDict={'side': 'buy', 'posBuy': 0, 'posSell': 0, 'isNewDay': True, 'isOpenBuy': False, 'isOpenSell': False, 'isCloseBuy': True, 'isCloseSell': True, 'isOpen': False, 'isClose': True, 'isTrig': False}
127.0.0.1 - - [20/Jan/2023 08:10:01] "POST / HTTP/1.1" 200 -

--handleKline--:  self.name='modifiedmom', self.symbol='BTCUSDT', interval='10m', intervalSec=600, self.count=8024 

self.closeSec=1674173399, self.tradeDate='20230120', self.openTime='080000', self.closeTime='080959', self.symbol='BTCUSDT', self.open='21068.3', self.close='21056.8'
2023-01-20 08:10:01,551:INFO:modifiedmom:main.py:144:handleKline:185213: self.closeSec=1674173399, self.tradeDate='20230120', self.openTime='080000', self.closeTime='080959',self.symbol='BTCUSDT',self.open='21068.3', self.close='21056.8'
2023-01-20 08:10:01,604:INFO:modifiedmom:main.py:145:handleKline:185213: ukdf.iloc[-5:,:] :
    tradeDate openTime closeTime    closeSec     open    close       pct
620  20230120   072000    072959  1674170999  21024.8  21059.3  0.001631
621  20230120   073000    073959  1674171599  21059.3  21055.8 -0.000166
622  20230120   074000    074959  1674172199  21055.8  21057.7  0.000090
623  20230120   075000    075959  1674172799  21056.7  21068.3  0.000503
624  20230120   080000    080959  1674173399  21068.3  21056.8 -0.000546
2023-01-20 08:10:01,606:INFO:modifiedmom:main.py:146:handleKline:185213: self.flagDict={'side': 'buy', 'posBuy': 0, 'posSell': 0, 'isNewDay': True, 'isOpenBuy': False, 'isOpenSell': False, 'isCloseBuy': True, 'isCloseSell': True, 'isOpen': False, 'isClose': True, 'isTrig': False}


## /root/FIL/strategy/pyemd/log.txt ----- -----

17470  20230120   074000    074959  1674172199  21055.8  21057.7
2023-01-20 07:50:00,829:INFO:pyemd2:main.py:127:handleKline:185189: self.flagDict={'side': 'sell', 'posBuy': 0, 'posSell': 0, 'isNewDay': True, 'isOpenBuy': False, 'isOpenSell': False, 'isCloseBuy': True, 'isCloseSell': False, 'isOpen': False, 'isClose': True, 'isTrig': False}

--handleKline--:  self.name='pyemd2', self.symbol='BTCUSDT', interval='10m', intervalSec=600, self.count=8024 

self.closeSec=1674172799, self.tradeDate='20230120', self.openTime='075000', self.closeTime='075959', self.symbol='BTCUSDT', self.open='21056.7', self.close='21068.3'
127.0.0.1 - - [20/Jan/2023 08:00:01] "POST / HTTP/1.1" 200 -
2023-01-20 08:00:01,520:INFO:pyemd2:main.py:125:handleKline:185189: self.closeSec=1674172799, self.tradeDate='20230120', self.openTime='075000', self.closeTime='075959',self.symbol='BTCUSDT',self.open='21056.7', self.close='21068.3'
2023-01-20 08:00:01,547:INFO:pyemd2:main.py:126:handleKline:185189: ukdf.iloc[-5:,:] :
      tradeDate openTime closeTime    closeSec     open    close
17467  20230120   071000    071959  1674170399  21037.4    21025
17468  20230120   072000    072959  1674170999  21024.8  21059.3
17469  20230120   073000    073959  1674171599  21059.3  21055.8
17470  20230120   074000    074959  1674172199  21055.8  21057.7
17471  20230120   075000    075959  1674172799  21056.7  21068.3
2023-01-20 08:00:01,547:INFO:pyemd2:main.py:127:handleKline:185189: self.flagDict={'side': 'sell', 'posBuy': 0, 'posSell': 0, 'isNewDay': True, 'isOpenBuy': False, 'isOpenSell': False, 'isCloseBuy': True, 'isCloseSell': False, 'isOpen': False, 'isClose': True, 'isTrig': False}
127.0.0.1 - - [20/Jan/2023 08:10:01] "POST / HTTP/1.1" 200 -

--handleKline--:  self.name='pyemd2', self.symbol='BTCUSDT', interval='10m', intervalSec=600, self.count=8025 

self.closeSec=1674173399, self.tradeDate='20230120', self.openTime='080000', self.closeTime='080959', self.symbol='BTCUSDT', self.open='21068.3', self.close='21056.8'
2023-01-20 08:10:01,590:INFO:pyemd2:main.py:125:handleKline:185189: self.closeSec=1674173399, self.tradeDate='20230120', self.openTime='080000', self.closeTime='080959',self.symbol='BTCUSDT',self.open='21068.3', self.close='21056.8'
2023-01-20 08:10:01,599:INFO:pyemd2:main.py:126:handleKline:185189: ukdf.iloc[-5:,:] :
      tradeDate openTime closeTime    closeSec     open    close
17468  20230120   072000    072959  1674170999  21024.8  21059.3
17469  20230120   073000    073959  1674171599  21059.3  21055.8
17470  20230120   074000    074959  1674172199  21055.8  21057.7
17471  20230120   075000    075959  1674172799  21056.7  21068.3
17472  20230120   080000    080959  1674173399  21068.3  21056.8
2023-01-20 08:10:01,599:INFO:pyemd2:main.py:127:handleKline:185189: self.flagDict={'side': 'sell', 'posBuy': 0, 'posSell': 0, 'isNewDay': True, 'isOpenBuy': False, 'isOpenSell': False, 'isCloseBuy': True, 'isCloseSell': False, 'isOpen': False, 'isClose': True, 'isTrig': False}


## /root/FIL/strategy/similarity/log.txt ----- -----

12142  20230120   074000    074959  1674172199  21055.8  21057.7
2023-01-20 07:50:00,836:INFO:testStrategy:main.py:103:handleKline:185174: self.flagDict={'side': 'sell', 'posBuy': 0, 'posSell': 0, 'isNewDay': True, 'isOpenBuy': False, 'isOpenSell': True, 'isCloseBuy': False, 'isCloseSell': True, 'isOpen': True, 'isClose': False, 'isTrig': True, 'isCorr': False}
127.0.0.1 - - [20/Jan/2023 08:00:01] "POST / HTTP/1.1" 200 -

--handleKline--:  self.name='testStrategy', self.symbol='BTCUSDT', interval='10m', intervalSec=600, self.count=8024 

self.closeSec=1674172799, self.tradeDate='20230120', self.openTime='075000', self.closeTime='075959', self.symbol='BTCUSDT', self.open='21056.7', self.close='21068.3'
2023-01-20 08:00:01,514:INFO:testStrategy:main.py:101:handleKline:185174: self.closeSec=1674172799, self.tradeDate='20230120', self.openTime='075000', self.closeTime='075959',self.symbol='BTCUSDT',self.open='21056.7', self.close='21068.3'
2023-01-20 08:00:01,541:INFO:testStrategy:main.py:102:handleKline:185174: ukdf.iloc[-5:,:] :
      tradeDate openTime closeTime    closeSec     open    close
12139  20230120   071000    071959  1674170399  21037.4    21025
12140  20230120   072000    072959  1674170999  21024.8  21059.3
12141  20230120   073000    073959  1674171599  21059.3  21055.8
12142  20230120   074000    074959  1674172199  21055.8  21057.7
12143  20230120   075000    075959  1674172799  21056.7  21068.3
2023-01-20 08:00:01,541:INFO:testStrategy:main.py:103:handleKline:185174: self.flagDict={'side': 'sell', 'posBuy': 0, 'posSell': 0, 'isNewDay': True, 'isOpenBuy': False, 'isOpenSell': True, 'isCloseBuy': False, 'isCloseSell': True, 'isOpen': True, 'isClose': False, 'isTrig': True, 'isCorr': False}

--handleKline--:  self.name='testStrategy', self.symbol='BTCUSDT', interval='10m', intervalSec=600, self.count=8025 

self.closeSec=1674173399, self.tradeDate='20230120', self.openTime='080000', self.closeTime='080959', self.symbol='BTCUSDT', self.open='21068.3', self.close='21056.8'
2023-01-20 08:10:01,575:INFO:testStrategy:main.py:101:handleKline:185174: self.closeSec=1674173399, self.tradeDate='20230120', self.openTime='080000', self.closeTime='080959',self.symbol='BTCUSDT',self.open='21068.3', self.close='21056.8'
127.0.0.1 - - [20/Jan/2023 08:10:01] "POST / HTTP/1.1" 200 -
2023-01-20 08:10:01,601:INFO:testStrategy:main.py:102:handleKline:185174: ukdf.iloc[-5:,:] :
      tradeDate openTime closeTime    closeSec     open    close
12140  20230120   072000    072959  1674170999  21024.8  21059.3
12141  20230120   073000    073959  1674171599  21059.3  21055.8
12142  20230120   074000    074959  1674172199  21055.8  21057.7
12143  20230120   075000    075959  1674172799  21056.7  21068.3
12144  20230120   080000    080959  1674173399  21068.3  21056.8
2023-01-20 08:10:01,601:INFO:testStrategy:main.py:103:handleKline:185174: self.flagDict={'side': 'sell', 'posBuy': 0, 'posSell': 0, 'isNewDay': True, 'isOpenBuy': False, 'isOpenSell': True, 'isCloseBuy': False, 'isCloseSell': True, 'isOpen': True, 'isClose': False, 'isTrig': True, 'isCorr': False}


## /root/FIL/strategy/sr_min/log.txt ----- -----

--handleKline--:  version='2.0.0', self.name='sr_min', self.symbol='BTCUSDT', interval='5m', intervalSec=300, wid=192, thd=0.88, self.sign=0, self.total=1000000.0, self.flagDict['side']='', self.tradeCount=0, self.count=11480
self.closeSec=1674173399, self.tradeDate='20230120', self.openTime='080500', self.closeTime='080959', self.symbol='BTCUSDT', self.open=21083.2, self.close=21056.8, self.high=21095.2, self.low=21056.8, self.vol=1093.351, self.amt=23048909.1558 
127.0.0.1 - - [20/Jan/2023 08:10:01] "POST / HTTP/1.1" 200 -
2023-01-20 08:10:01,518:INFO:sr_min:main.py:172:handleKline:449472: ukdf.iloc[-5:,:] :
     tradeDate openTime closeTime  ...  value_mean  value_std  signal
5853  20230120   074500    074959  ...         0.0        0.0       0
5854  20230120   075000    075459  ...         0.0        0.0       0
5855  20230120   075500    075959  ...         0.0        0.0       0
5856  20230120   080000    080459  ...         0.0        0.0       0
5857  20230120   080500    080959  ...         0.0        0.0       0

[5 rows x 18 columns]
2023-01-20 08:10:01,519:INFO:sr_min:main.py:175:handleKline:449472: self.closeSec=1674173399, self.tradeDate='20230120', self.openTime='080500', self.closeTime='080959',self.symbol='BTCUSDT',self.open=21083.2, self.close=21056.8, self.high=21095.2, self.low=21056.8, self.vol=1093.351, self.amt=23048909.1558, ukdf['pct'].iloc[-1]=-0.001224 , ukdf['amount'].iloc[-1]=23048909.1558, ukdf['indicator'].iloc[-1]=0.0, ukdf['index'].iloc[-1]=5857, value=0.0, value_mean=0.0, signal=0, value_std=0.0 
queryPositions: self.symbol='BTCUSDT', positions=PositionsReturn{'result': []}
type(curSign)=<class 'int'>, curSign=0, self.sign=0
--handleKline--:  version='2.0.0', self.name='sr_min', self.symbol='BTCUSDT', interval='5m', intervalSec=300, wid=192, thd=0.88, self.sign=0, self.total=1000000.0, self.flagDict['side']='', self.tradeCount=0, self.count=11481
self.closeSec=1674173699, self.tradeDate='20230120', self.openTime='081000', self.closeTime='081459', self.symbol='BTCUSDT', self.open=21056.8, self.close=21056.7, self.high=21076.3, self.low=21048.9, self.vol=1055.965, self.amt=22238675.4343 
127.0.0.1 - - [20/Jan/2023 08:15:00] "POST / HTTP/1.1" 200 -
2023-01-20 08:15:00,795:INFO:sr_min:main.py:172:handleKline:449472: ukdf.iloc[-5:,:] :
     tradeDate openTime closeTime  ...  value_mean  value_std  signal
5854  20230120   075000    075459  ...         0.0        0.0       0
5855  20230120   075500    075959  ...         0.0        0.0       0
5856  20230120   080000    080459  ...         0.0        0.0       0
5857  20230120   080500    080959  ...         0.0        0.0       0
5858  20230120   081000    081459  ...         0.0        0.0       0

[5 rows x 18 columns]
2023-01-20 08:15:00,795:INFO:sr_min:main.py:175:handleKline:449472: self.closeSec=1674173699, self.tradeDate='20230120', self.openTime='081000', self.closeTime='081459',self.symbol='BTCUSDT',self.open=21056.8, self.close=21056.7, self.high=21076.3, self.low=21048.9, self.vol=1055.965, self.amt=22238675.4343, ukdf['pct'].iloc[-1]=-5e-06 , ukdf['amount'].iloc[-1]=22238675.4343, ukdf['indicator'].iloc[-1]=0.0, ukdf['index'].iloc[-1]=5858, value=0.0, value_mean=0.0, signal=0, value_std=0.0 
queryPositions: self.symbol='BTCUSDT', positions=PositionsReturn{'result': []}
type(curSign)=<class 'int'>, curSign=0, self.sign=0


## /root/FIL/strategy/s_rsrs/log.txt ----- -----

719  20230119   200000    235959  1674143999  ...    719  0.166687 -1.446583    -1.0
720  20230120   000000    035959  1674158399  ...    720  0.157312 -1.432139    -1.0

[5 rows x 15 columns]
queryPositions: self.symbol='BTCUSDT', positions=PositionsReturn{'result': [PositionType{'sysID': SystemID{'mainID': '', 'subID': '', 'strategyID': ''}, 'symbol': 'BTCUSDT', 'positionAmount': '51.053', 'enterprice': '21166.9', 'countrevence': '0', 'unrealprofit': '3744.81247946704', 'marginmodel': 0, 'isolatedmargin': '0', 'positionside': 'short', 'markprice': '21093.54853232', 'status': 'none', 'closeprice': '0', 'closeamount': '0', 'opentime': 0, 'closetime': 0, 'type': 'AssetType_ucontract'}]}
type(curSign)=<class 'numpy.int64'>, curSign=-1, self.sign=-1
127.0.0.1 - - [20/Jan/2023 08:00:01] "POST / HTTP/1.1" 200 -
--handleKline--:  version='2.0.0', self.name='s_rsrs', self.symbol='BTCUSDT', interval='4h', intervalSec=14400, wid=25, thd=0.6, self.sign=-1, self.total=1079553.1119543002, self.flagDict['side']='sell', self.tradeCount=13, self.count=334
self.closeSec=1674172799, self.tradeDate='20230120', self.openTime='040000', self.closeTime='075959', self.symbol='BTCUSDT', self.open=21090.1, self.close=21068.3, self.high=21183.9, self.low=20913.4, self.vol=66652.701, self.amt=1403444899.7261 
2023-01-20 08:00:01,403:INFO:s_rsrs:main.py:141:handleKline:185271: self.closeSec=1674172799, self.tradeDate='20230120', self.openTime='040000', self.closeTime='075959',self.symbol='BTCUSDT',self.open=21090.1, self.close=21068.3, self.high=21183.9, self.low=20913.4, self.vol=66652.701, self.amt=1403444899.7261 
2023-01-20 08:00:01,453:INFO:s_rsrs:main.py:142:handleKline:185271: ukdf.iloc[-5:,:] :
    tradeDate openTime closeTime  ...         vol           amt       pct
717  20230119   120000    155959  ...   31249.692  6.507700e+08  0.003335
718  20230119   160000    195959  ...   39443.433  8.193602e+08 -0.003684
719  20230119   200000    235959  ...  108038.719  2.247319e+09  0.006239
720  20230120   000000    035959  ...   86336.471  1.809397e+09  0.010508
721  20230120   040000    075959  ...   66652.701  1.403445e+09 -0.001034

[5 rows x 11 columns]
2023-01-20 08:00:03,499:INFO:s_rsrs:main.py:151:handleKline:185271: df_s.iloc[-5:,:] :
    tradeDate openTime closeTime    closeSec  ...  index      beta    zscore  signal
717  20230119   120000    155959  1674115199  ...    717  0.204434 -1.425282    -1.0
718  20230119   160000    195959  1674129599  ...    718  0.195458 -1.412865    -1.0
719  20230119   200000    235959  1674143999  ...    719  0.166687 -1.446583    -1.0
720  20230120   000000    035959  1674158399  ...    720  0.157312 -1.432139    -1.0
721  20230120   040000    075959  1674172799  ...    721  0.148034 -1.417982    -1.0

[5 rows x 15 columns]
queryPositions: self.symbol='BTCUSDT', positions=PositionsReturn{'result': [PositionType{'sysID': SystemID{'mainID': '', 'subID': '', 'strategyID': ''}, 'symbol': 'BTCUSDT', 'positionAmount': '51.053', 'enterprice': '21166.9', 'countrevence': '0', 'unrealprofit': '4916.49333209275', 'marginmodel': 0, 'isolatedmargin': '0', 'positionside': 'short', 'markprice': '21070.59824825', 'status': 'none', 'closeprice': '0', 'closeamount': '0', 'opentime': 0, 'closetime': 0, 'type': 'AssetType_ucontract'}]}
type(curSign)=<class 'numpy.int64'>, curSign=-1, self.sign=-1


