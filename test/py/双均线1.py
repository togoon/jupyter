import tushare as ts
import pandas as pd
import talib


def edd_note(code):
    return "'"+code

def get_stock_data(code):
    df_raw=ts.get_k_data(code,autype='qfq')
    df_raw["code"]=df_raw.apply(lambda x: add_note(x,code),axis=1)
    df_raw.to.csv(code+'.csv')
    return code + '.csv'

def compare_diff(paraml):...




def calculate_sma(filename,ma1=5,ma2=10):
    df=pd.read_csv(filename,index_col='date')
    df['sma_'+str(ma1)]=talib.MA(df['close'],timeperiod=ma1)
    df['sma_'+str(ma2)]=talib.MA(df['close'],timeperiod=ma2)
    df['compare']=df.apply(lambda x: compare_diff(x['sma_'+str(ma1)], x['sma_'+str(ma2)]))
    df=df[9:]
    df.to_csv("sma_data.csv")
    return df

def tag(match,compare):
    if match ==False and compare ==1:
        return "买入"
    if match ==False and compare ==-1:
        return "卖出"

def sell_and_buy(df,ma1=5,ma2=10):
    df['match']=df.compare == df.compare.shift()
    df.to_csv("sma_change.csv")

    df["tag"]=df.apply(lambda row:tag(row.match,row.compare),axis=1)
    df.to_csv("result.csv")

def cal_profit():
    df=pd.read_csv("result.csv",index_col='data')
    df["profit"]=0
    total=0
    win=0


    buyprice=0
    for index,row in df.iterrows():
        if row.tag=='买入':
            buyprice=row.close
        if row.tag=='卖出' and buyprice !=0:
            total+=1
        df.loc[index,'profit']=row.close-buyprice
        if row.close-buyprice>0:
            win+=1
    percent=round((win / total)*100, 2)
    profit=round(df["profit"].sum(),2)
    print("开平仓次数:",total,"\n盈利次数:",win,"\n成功率:",percent,"%","\n总共盈亏:",profit)
    df.to_csv("profit.csv")











if __name__ == '__main__':
    print("===简单双均线策略===")
    code='000651'
    ma1=5
    ma2=10
    filename=get_stock_data(code)
    df=calculate_sma(filename,ma1,ma2)
    sell_and_buy(df,ma1,ma2)
    cal_profit()
