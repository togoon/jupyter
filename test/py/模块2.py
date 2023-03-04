import requests
import sys
import io

base_url='http://www.nmpa.gov.cn/WS04/CL2065/'
headers={'User-Agent':'Mozilla/4.0(compatible; MSIE 6.0; Windows NT 5.1; SV1)','Accept-Ranges':'bytes',
'Content-Length':'3702','Content-Type':'image/png'}
response=requests.get(base_url,headers=headers)
html_str=response.text

print(html_str)

