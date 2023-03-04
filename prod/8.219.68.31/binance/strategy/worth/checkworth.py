# binance.db

import os
import sqlite3
import pandas as pd

worth_real_dbfile = f"worth.db"

if os.path.exists(worth_real_dbfile):
    # print(f"{worth_real_dbfile}  exists ")

    conn = sqlite3.connect(worth_real_dbfile)

    df_balance = pd.read_sql(' select * from balance ', conn) 
    # access accountAlias asset availableBalance balance crossUnPnl crossWalletBalance marginAvailable maxWithdrawAmount queryTime updateDate updateTime
    # print(f"df_balance.iloc[-5:,:] :\n {df_balance.iloc[-5:,:]} \n")
    df_b = df_balance[['access','asset','balance','availableBalance','updateTime','queryTime', ] ]
    print(f"df_b.iloc[-5:,:] :\n {df_b.iloc[-5:,:]} \n")

    df_orders = pd.read_sql(' select * from orders ', conn)
    # access avgPrice clientOrderId closePosition cumQuote executedQty orderId origQty origType positionSide price priceProtect queryTime reduceOnly side status stopPrice symbol time timeInForce type updateDate updateTime workingType
    # print(f"df_orders.iloc[-5:,:] :\n {df_orders.iloc[-5:,:]} \n")
    df_o = df_orders[['access','orderId','symbol','price','origQty','status','updateDate','clientOrderId', ] ]
    print(f"df_o.iloc[-5:,:] :\n {df_o.iloc[-5:,:]} \n")

    df_posirisk = pd.read_sql(' select * from posirisk ', conn) 
    # access entryPrice isAutoAddMargin isolatedMargin isolatedWallet leverage liquidationPrice marginType markPrice maxNotionalValue notional positionAmt positionSide queryTime symbol unRealizedProfit updateDate updateTime
    # print(f"df_posirisk.iloc[-5:,:] :\n {df_posirisk.iloc[-5:,:]} \n")
    df_pr = df_posirisk[['access','symbol','markPrice','unRealizedProfit','leverage','entryPrice','positionAmt','notional','updateDate','queryTime', ] ]
    print(f"df_pr.iloc[-5:,:] :\n {df_pr.iloc[-5:,:]} \n")

    df_trades = pd.read_sql(' select * from trades ', conn) 
    # access buyer commission commissionAsset id maker marginAsset orderId positionSide price qty queryTime quoteQty realizedPnl side symbol time updateDate
    # print(f"df_trades.iloc[-5:,:] :\n {df_trades.iloc[-5:,:]} \n")
    df_tr = df_trades[['access','id','orderId','symbol','price','qty','side','positionSide','quoteQty', 'queryTime'] ]
    print(f"df_tr.iloc[-5:,:] :\n {df_tr.iloc[-5:,:]} \n")

    # df_a = df_account[['asset','walletBalance','availableBalance','maintMargin','marginBalance','unrealizedProfit','updateDate','queryTime', ] ]

    # rt_df.to_sql('account', con=conn, if_exists='append', index=False) #  replace替换 append追加
    conn.close()
