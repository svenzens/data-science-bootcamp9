from requests import get
from time import sleep
import pandas as pd
import csv

url = "https://api.coincap.io/v2/markets"

res = get(url).json()
# print(res)

head = ['baseSymbol', 'baseId', 'quoteSymbol', 'priceUSD', 'percentExVol']
detail = []

for data in res["data"][:10]:
    baseSymbol = data["baseSymbol"]
    baseId = data["baseId"]
    quoteSymbol = data["quoteSymbol"]
    priceUSD = data["priceUsd"]
    percentExVol = data["percentExchangeVolume"]
    detail.append([baseSymbol, baseId, quoteSymbol, priceUSD, percentExVol])
    sleep(1)

## write json to csv
with open("cc.csv", "w") as file:
    writer = csv.writer(file)
    writer.writerow(head)
    writer.writerows(detail)

## read csv
coin_cap = pd.read_csv("cc.csv")
coin_cap
