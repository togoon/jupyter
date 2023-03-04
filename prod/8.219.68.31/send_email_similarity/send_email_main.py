#!/usr/bin/python3
# -*- coding: UTF-8 -*-

import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from email.header import Header
from datetime import date
import datetime
import time
import os
from json import load
import sqlite3
import pandas as pd

def get_real_name(filename):
    dir_name = os.path.dirname(filename)
    base = os.path.basename(filename)
    base_list=base.split('|')
    today = date.today()
    delta = 0
    for index in range(0, len(base_list)):
        base_part = base_list[index]
        if len(base_part) > 0 and base_part[0] == '%':
            if base_part[-2:] == '_1':
                fmt = base_part[:-2]
                delta = 1
            else:
                fmt = base_part
            day = today - datetime.timedelta(days=delta)
            base_list[index] = day.strftime(fmt)
    return os.path.join(dir_name, ''.join(base_list))


def send_email(host, user, pwd, sub, receivers, files, text=None, html=None):
    # 第三方 SMTP 服务
    #设置服务器
    sender = user
    message = MIMEMultipart()
    message['From'] = user
    message['To'] = ','.join(receivers)
    subject = '%s, 日期%s' %(sub, date.today().strftime('%Y%m%d'))

    # 邮件正文内容
    if text is not None:
        message.attach(MIMEText(text, 'plain', 'utf-8'))
    else:
        message.attach(MIMEText(subject, 'plain', 'utf-8'))
    if html is not None:
        message = MIMEText(html, 'html', 'utf-8')
    # 附件1
    for filename in files:
        real_name = get_real_name(filename)
        if not os.path.exists(real_name):
            print("Not Found filename=%s" % real_name)
            continue
        file_base_name = os.path.basename(real_name)
        att1 = MIMEText(open(real_name, 'rb').read(), 'base64', 'utf-8')
        att1["Content-Type"] = 'application/octet-stream'
        # 这里的filename可以任意写，写什么名字，邮件中显示什么名字
        att1["Content-Disposition"] = 'attachment; filename="%s"' % file_base_name
        message.attach(att1)
    message['Subject'] = Header(subject, 'utf-8')
    try:
        stime = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())
        smtpObj = smtplib.SMTP_SSL(host)
        smtpObj.connect(host, 465)    # 25 为 SMTP 端口号
        # smtpObj = smtplib.SMTP(host=host, port=587)
        # smtpObj.ehlo()
        # smtpObj.starttls()
        smtpObj.set_debuglevel(1)
        smtpObj.login(user, pwd)
        smtpObj.sendmail(sender, receivers, message.as_string())
        print( stime + ":邮件发送成功")
    except smtplib.SMTPException as e:
        print(e)
        print(stime + ":Error: 无法发送邮件")


def mailWrite(table_content=None, plist=None):
    #表格的标题和头
    header = '<html><head><meta name="viewport" http-equiv="Content-Type" content="width=device-width, ' \
             'initial-scale=1.0, minimum-scale=0.5, maximum-scale=2.0, user-scalable=no, charset=utf-8" /></head> ' \
             '<body text="#000000" >'
    th = '<table border="1" style="font-size: 8px" cellspacing="0" cellpadding="3" bordercolor="#000000"' \
         '><tr bgcolor="#F79646" align="left" ></tr>'
    tail = '</body></html>'
    if table_content is not None:
        columns = table_content.columns
        for c in columns:
            th = th + '<th>' + c + '</th>'
        th = th + '</tr>'
        c_len = len(columns)
        r_len = len(table_content)
        tr = ''
        for i in range(r_len):
            td = ''
            for j in range(c_len):
                cellData = str(table_content.iloc[i,j])
                #读取单元格数据，赋给cellData变量供写入HTML表格中
                tip = '<td>' + cellData + '</td>'
                td = td + tip
            tr = tr + '<tr>' + td + '</tr>'
        tr = tr + '</table>'
    p = ''
    if plist is not None:
        for item in plist:
            p = p + '<p style="font-family:verdana;color:red">' + item + '</p>'
    mailcontent = header + p + th + tr + tail
    print(mailcontent)
    return mailcontent


def read_from_db(fn, sql):
    conn = sqlite3.connect(fn)
    cursor = conn.cursor()
    cursor.execute(sql)
    columns = [x[0] for x in cursor.description]
    results = cursor.fetchall()
    conn.close()
    return pd.DataFrame(results, columns=columns)


def main():
    cfg_file = 'send_email_cfg.json'
    if os.path.exists(cfg_file):
        with open(cfg_file, 'r', encoding='GBK') as f:
            config = load(f)
    else:
        print('Not Found file send_email_cfg.json!')
        return 0
    mail_host = config['mail_host']
    mail_user = config['mail_user']
    mail_pass = config['mail_pass']
    receivers = config['receivers']
    filename = config['filename']
    subject = config['subject']
    html_content = config.get('html_content', {})
    trade_content = pd.DataFrame()
    p_content = []
    if len(html_content):
        fn  = html_content['db_file_path']
        diff_min = html_content['diff']
        capital = html_content['capital']
        stoploss1 = html_content['stoploss1']
        stoploss2 = html_content['stoploss2']
        send_time = html_content['send_time']
        now = int(time.time())
        start = (now - now % 60 - diff_min * 60) * 1000
        trade_sql = html_content['sql'] % start
        trade_content = read_from_db(fn, trade_sql)
        balance_sql = '''select balance from balance where access='similarity_big' order by querytime desc LIMIT 1'''
        balance_content = read_from_db(fn, balance_sql)
        if len(balance_content) > 0:
            balance = float(balance_content.iloc[0, 0])
            nav = balance / capital
            if nav < stoploss2:
                p_content.append('已跌破止损线，当前单位净值为%.2f，止损线为%s' % (nav, stoploss2))
            elif nav < stoploss1:
                p_content.append('已跌破预警线，当前单位净值为%.2f，预警线为%s' % (nav, stoploss1))
            localtime = time.localtime(now)
            if send_time == localtime.tm_hour and localtime.tm_min < diff_min:
                p_content.append('今日净值为：%.2f' % balance)
    if len(trade_content) or len(p_content) or len(filename):
        send_email(mail_host, mail_user, mail_pass, subject, receivers, filename, html=mailWrite(trade_content, p_content))


if __name__ == '__main__':
    main()


