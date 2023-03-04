from urllib.parse import urlencode
import requests
import csv
import bs4
import pandas as pd

def get_one_page(i):
    paras={'reportTime':'2020-03-31','pageNum':i}
    url='https://s.askci.com/stock/a/?'+urlencode(paras)
    print(url)
