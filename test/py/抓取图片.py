
import requests
import parser
base_url='https://tieba.baidu.com/f?fr=wwwt&kw=%E7%BE%8E%E5%A5%B3'
headers={'User-Agent':'Mozilla/4.0(compatible; MSIE 6.0; Windows NT 5.1; SV1)'}

response=requests.get(base_url,headers=headers)
html_str=response.text

print(html_str)

html=parsel.Seletor(html_str)

title_url=html.xpath('//div[@class="threadlist_lz clearfix"]/div/a/@href').extract()
print(title_url)

sencond_url='https://tieba.baidu.com'

for url in title_url:
    all_url=sencond_url+url
    print(all_url)
    response_2=requests.get(all_url,headers=headers).text
    response_2data=parsel.Seletor(response_2)
