
import tushare as ts

def tur10(STOCK):
    qx = ts.get_hist_data('STOCK',start='2016-06-30',end='2017-06-30')
    stknum = 0

    dprice = qx.close
    x9 = max(qx.close[1:10])
    x1 = min(df.close[1:10])
    dcash = 1000000
    dumn0 = 0
    if dprice > x9:
        if dnum0 == 0:
            stkum = int(dcash*0.9 / dprice)
        elif (dprice < x1):
            stknum = -1
        if stknum !=0:
            pass

        return stknum

if __name__ == '__main__':
         ##娴﹀彂閾惰
    STOCK = '600898'
    tur10(STOCK)
