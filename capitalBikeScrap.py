import pandas as pd
import numpy as np
import json
import requests as re
from datetime import datetime

now = datetime.now()

query = re.get("https://gbfs.capitalbikeshare.com/gbfs/en/station_status.json")

data = query.text
data = json.loads(data)

dataframe = pd.DataFrame(data["data"]["stations"])
dataframe["time_and_day"] = now.strftime("%d/%m/%Y %H:%M:%S")

### Get the info for stations

stationInfo = re.get("https://gbfs.capitalbikeshare.com/gbfs/en/station_information.json")

Stationdata = stationInfo.text
Stationdata = json.loads(Stationdata)

Stationdataframe = pd.DataFrame(Stationdata["data"]["stations"])


result = pd.merge(dataframe, Stationdataframe[["name", "station_id", "lat", "lon", "region_id"]], on='station_id', how = "left")

result.to_csv('JumpStation.csv', mode='a', header=False)
