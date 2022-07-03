import csv
import sys
import urllib.request
import requests
import random
import json
from datetime import datetime
import uuid
import string
import sys

# the first argument is the baseUrl including http or https of the Azure Container Apps url
baseUrl = sys.argv[1]

StockSaveUrl= "{baseUrl}/refill/"
StockGetUrl= "{baseUrl}/balance/{id}"

for i in range(0,1000):
    sku = 'cookie' + str(i).zfill(3)
    data =     {  
    "SKU": sku,  
    "Quantity": -1000
    }

    url = StockSaveUrl.format(baseUrl=baseUrl)

    response = requests.post(url, json=data)
            
    if (response.status_code != 200):
        print(f'\tSKU:{sku}, error status code: {response.status_code}')
    else:
        url = StockGetUrl.format(baseUrl=baseUrl, id=sku)
        response = requests.get(url)

        if (response.status_code != 200):
            print(f'\tSKU:{sku}, error status code: {response.status_code}')
        else:
            print(f'\tSKU:{sku}, Balance: {response.text}')   



