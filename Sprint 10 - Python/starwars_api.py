# import module
import numpy as np
import pandas as pd
import csv
from requests import get
from time import sleep

url = "https://www.swapi.tech/api/people/"

head = ['name', 'gender', 'birth_year', 'height', 'mass']
data = []

for i in range(5):
  index = i + 1
  new_url = url + str(index)
  resp = get(new_url).json()
  try:
    ref = resp["result"]["properties"]
    name = ref["name"]
    gender = ref["gender"]
    birth_year = ref["birth_year"]
    height = ref["height"]
    mass = ref["mass"]
    sleep(1)
    data.append([name, gender, birth_year, height, mass])
  except KeyError:
    print("No Data")

## write json to csv
with open("starwars.csv", "w") as file:
    writer = csv.writer(file)
    writer.writerow(head)
    writer.writerows(data)

## read csv
sw_data = pd.read_csv("starwars.csv")
sw_data
