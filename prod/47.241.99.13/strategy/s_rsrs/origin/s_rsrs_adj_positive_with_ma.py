# -*- coding: UTF-8 -*-
import pandas as pd
import time
import datetime
import numpy as np
import warnings
from scipy import stats as st
import statsmodels.api as sm
from math import sqrt
from tqdm import tqdm
from itertools import product as product
from matplotlib import pyplot as plt
import pymssql
warnings.filterwarnings('ignore')
plt.rcParams['font.sans-serif']=['SimHei'] #用来正常显示中文标签
plt.rcParams['axes.unicode_minus']=False #用来正常显示负号
conn = pymssql.connect("127.0.0.1", "sa", "quant@123", "test_block")
cursor = conn.cursor()
warnings.filterwarnings("ignore")

def stat_depict_plot(df, col, title):
    df = df[~df[col].isna()].copy()

    avgRet = np.mean(df[col])
    medianRet = np.median(df[col])
    stdRet = np.std(df[col])
    skewRet = st.skew(df[col])
    kurtRet = st.kurtosis(df[col])

    plt.style.use('ggplot')
    # 画日对数收益率分布直方图
    fig = plt.figure(figsize=(18, 9))
    plt.suptitle(title)
    v = df[col]
    x = np.linspace(avgRet - 3 * stdRet, avgRet + 3 * stdRet, 100)
    y = st.norm.pdf(x, avgRet, stdRet)
    kde = st.gaussian_kde(v)

    # plot the histogram
    plt.subplot(121)
    plt.hist(v, 50, weights=np.ones(len(v)) / len(v), alpha=0.4)
    plt.axvline(x=avgRet, color='red', linestyle='--',
                linewidth=0.8, label='Mean Count')
    plt.axvline(x=avgRet - stdRet, color='blue', linestyle='--',
                linewidth=0.8, label='-1 Standard Deviation')
    plt.axvline(x=avgRet + stdRet, color='blue', linestyle='--',
                linewidth=0.8, label='1 Standard Deviation')
    plt.ylabel('Percentage', fontsize=10)
    plt.legend(fontsize=12)

    # plot the kde and normal fit
    plt.subplot(122)
    plt.plot(x, kde(x), label='Kernel Density Estimation')
    plt.plot(x, y, color='black', linewidth=1, label='Normal Fit')
    plt.ylabel('Probability', fontsize=10)
    plt.axvline(x=avgRet, color='red', linestyle='--',
                linewidth=0.8, label='Mean Count')
    plt.legend(fontsize=12)
    return plt.show()

def stat_depict(df, col, pr=True):
    df = df[~df[col].isna()].copy()
    # 计算总和的统计量
    avgRet = np.mean(df[col])
    medianRet = np.median(df[col])
    stdRet = np.std(df[col])
    skewRet = st.skew(df[col])
    kurtRet = st.kurtosis(df[col])
    if pr:
        print(
            """
        平均数 : %.4f
        中位数 : %.4f
        标准差 : %.4f
        偏度   : %.4f
        峰度   : %.4f
        1 Standard Deviation : %.4f
        -1 Standard Deviation : %.4f
        """ % (avgRet, medianRet, stdRet, skewRet, kurtRet, avgRet+stdRet, avgRet-stdRet)
        )
    else:
        return dict(zip('平均数,中位数,标准差,偏度,峰度,1 Standard Deviation,-1 Standard Deviation'.split(','),
                        map(lambda x: '{:.4%}'.format(x), [avgRet, medianRet, stdRet, skewRet, kurtRet,
                                                           avgRet+stdRet, avgRet-stdRet])))

def plot_average_cumulative_return(df, factor_name, after=10, title=None, probability=True, prt=True):
    '''
    df 因子计算后的df
    factor_name df中因子的名称
    title 图标的标题
    after 之后N日
    probability True计算概率 False 计算平均收益
    '''
    RSRS = df[['close', factor_name]].copy()
    # 计算未来N日收益率
    RSRS['ret'] = RSRS.close.pct_change(after).shift(-after)
    group = pd.cut(RSRS[factor_name], 50)
    RSRS['group'] = group
    if probability:
        # 计算上涨概率
        after_ret = RSRS.groupby('group')['ret'].apply(lambda x: np.sum(np.where(x > 0, 1, 0)) / len(x))
    else:
        after_ret = RSRS.groupby('group')['ret'].mean()

    if prt:
        # 画图
        plt.figure(figsize=(18, 6))
        # 设置标题
        plt.title(title)
        size = len(after_ret)
        plt.bar(range(size), after_ret.values, width=0.8, alpha=0.5)
        # rotation旋转x轴标签
        plt.xticks(range(size), after_ret.index.categories.right, rotation=30)
        # 设置y轴标题
        plt.ylabel('上涨概率')
        plt.show()
    else:
        return after_ret

def corr_depict(df,col_name):
    df_s = df.copy()
    corr_t_wid = 20
    df_s['ret'] = df_s.close.pct_change(corr_t_wid).shift(-corr_t_wid)
    zr_df = plot_average_cumulative_return(df_s, col_name, after=corr_t_wid, prt=False, probability=False)
    zr_df.index = zr_df.index.categories.right
    zr_df = zr_df.fillna(0)
    zr_df = zr_df.reset_index()
    zr_df.columns = ['factor', 'ret']

    rq = zr_df.query('factor>0')
    cor_right = np.corrcoef(rq['factor'], rq['ret'])[0][1]

    rq = zr_df.query('factor<0')
    cor_left = np.corrcoef(rq['factor'], rq['ret'])[0][1]

    rq = zr_df
    cor_all = np.corrcoef(rq['factor'], rq['ret'])[0][1]
    return cor_all,cor_right,cor_left


def func(idx, df):
    idx = [int(i) for i in idx]
    result_ = st.linregress(df['low'][idx], df['high'][idx]) # # slope intercept rvalue pvalue
    ret = (result_[0]**2)*(result_[2]**2)
    # r_2 = (result_[0]**2)*(result_[2]**2)
    return ret

def get_regression(data,reg_window):
    df_s = data.copy()
    df_s['index'] = range(len(df_s))
    # cal regression beta
    df_s['beta'] = df_s['index'].rolling(reg_window).apply(lambda x: func(x, df_s))
    del df_s['index']
    df_s.to_csv("ds_reg_"+str(reg_window)+".csv",index=False)
    return df_s


def get_data(data,reg_window,stat_wid,thd,if_print):
    cost_ = -0.0016
    # df_s = data.copy()
    # df_s['index'] = range(len(df_s))
    # # cal regression beta
    # df_s['beta'] = df_s['index'].rolling(reg_window).apply(lambda x: func(x, df_s))
    # del df_s['index']
    df_s = pd.read_csv("ds_reg_"+str(reg_window)+".csv")


    df_s['zscore'] = (df_s['beta']-df_s['beta'].rolling(stat_wid).mean())/df_s['beta'].rolling(stat_wid).std()

    df_s['ma'] = df_s['close'].rolling(60).mean()


    df_s.dropna(how='any',inplace=True)
    df_s.reset_index(drop=True,inplace=True)
    # print(df_s)
    # signal
    df_s['signal'] = np.nan
    # df_s['signal'] = np.where((df_s['zscore']>thd)&(df_s['close']>df_s['ma']),1,df_s['signal'])
    # df_s['signal'] = np.where((df_s['zscore'] < -thd)&(df_s['close']<df_s['ma']), -1, df_s['signal'])
    df_s['signal'] = np.where((df_s['zscore'] > thd), 1, df_s['signal'])
    df_s['signal'] = np.where((df_s['zscore'] < -thd), -1, df_s['signal'])

    df_s['position'] = df_s['signal']
    df_s['position'].iloc[0] = 0
    df_s['position'].fillna(method='pad',inplace=True)
    df_s['indicator'] = np.where(df_s['position']!=df_s['position'].shift(1),1,0)
    df_s['position'] = np.where(df_s['position']!=df_s['position'].shift(1),df_s['position'].shift(1),df_s['position'])
    # 是否可以做空
    # df_s['position'] = np.where(df_s['position']==-1,0,df_s['position'])

    df_s['pct'] = (df_s['close']/df_s['close'].shift(1) - 1)*df_s['position'] + df_s['indicator']*cost_
    std_ = np.std(df_s['pct'])*sqrt(365*6)
    df_s['nav'] = (df_s['pct'] + 1).cumprod()
    df_s['pct'] = df_s['close'] / df_s['close'].iloc[0]
    df_s['x'] = df_s.index
    # plot_average_cumulative_return(df_s, 'zscore', after=10, title='标准分未来10日上涨概率')
    # plot_average_cumulative_return(df_s, 'zscore', after=20, title='修正标准分未来10日期望收益', probability=False)
    corr_all,corr_right,corr_left=corr_depict(df_s,'zscore')
    # plt.plot
    # df_s.to_csv(r"C:\Users\wangjian\Desktop\\data_result.csv",index=False)

    # 画图
    if if_print==1:
        fig = plt.figure(figsize=(5, 5))
        ax1 = fig.add_subplot(1, 1, 1)
        ax1.plot(df_s['nav'],'r-', label='strategy')
        ax1.plot(df_s['pct'],'k-', label='raw')
        plt.xlabel('time')
        plt.ylabel('nav')
        plt.title('RSRS_NAV')
        plt.show()
    # cal re,std_
    re_ = df_s['nav'].iloc[-1]**(365.0*6/len(df_s.index)) - 1
    # print(df_s['nav'].iloc[-1],len(df_s.index))


    # df_s.dropna(how='any',inplace=True)
    # stat_depict(df_s, 'beta')
    # stat_depict_plot(df_s, 'beta', 'distribution')
    # cal regression zscore


    return re_,std_,re_/std_,corr_all,corr_right,corr_left

def loading_data(cate_id):
    sql_str = "SELECT ymd+' '+hms,[open],high,low,[close]  FROM [test_block].[dbo].[adj_data]" \
              "  where category = '"+str(cate_id)+"' and window=240  and ymd>'2020-12-31' order by ymd,hms"
    cursor.execute(sql_str)
    df_id = pd.DataFrame(cursor.fetchall(), columns=['timestamp','open','high','low','close'])
    # print(df_id)
    return df_id




#####################################################################################################################
#   Main Code
#####################################################################################################################
if __name__ == '__main__':
    # parameter
    if_print = 1
    reg_wid = 10 + (np.arange(10)) * 5
    stat_wid = 60 + (np.arange(10)) * 30
    threshold = 0.5 + (np.arange(20)) * 0.1



    df_input = loading_data('btc')
    df_para = pd.DataFrame(list(product(reg_wid, stat_wid,threshold)))
    df_para['re']=np.nan
    df_para['std'] = np.nan
    df_para['sr'] =np.nan
    df_para['corr_all'] = np.nan
    df_para['corr_right'] = np.nan
    df_para['corr_left'] = np.nan

    for i_reg in reg_wid:
        print("reg_para:",i_reg)
        get_regression(df_input, i_reg)

    for index_para,row_para in tqdm(df_para.iterrows(),total=len(df_para.index)):
        # print(row)
        if index_para!=621:
            continue
        df_para['re'].iloc[index_para],df_para['std'].iloc[index_para],df_para['sr'].iloc[index_para], \
            df_para['corr_all'].iloc[index_para],df_para['corr_right'].iloc[index_para],df_para['corr_left'].iloc[index_para] \
            = get_data(df_input, int(row_para[0]), int(row_para[1]), row_para[2],if_print)
        # df_para.to_csv(r"rsrs_adj_with_ma.csv")
        break
    # print(df_para)