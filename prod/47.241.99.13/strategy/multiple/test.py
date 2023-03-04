import requests
res = requests.get(f'http://fapi.binance.com/fapi/v1/time')
print(f'{res.text}')
