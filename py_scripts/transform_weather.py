"""
A script to clean and combine all extracted csvs
"""

import os
from config import countries, csv_outpath_weather
import datetime

import pandas as pd

def main():
    weather_data = {
        "country": [],
        "subdivision": [],
        "temp_c": [],    
        "rel_humid": [],
        "wind_speed": [],
        "year" : []
    }   

    # for each country 
    for country, info in countries.items():
        subdiv_code = info["subdiv_code"]

        # for each production csv
        weather_source = os.path.join(csv_outpath_weather, country)
        # get all csvs for production
        wcsv = os.listdir(weather_source)

        for csv in wcsv:
            file = os.path.join(weather_source, csv)
            wdf = pd.read_csv(file)

            # get subdiv
            code = csv[:2]
            subdiv = subdiv_code[code]

            # get year 
            wdf['valid'] = pd.to_datetime(wdf['valid'])
            wdf['Year'] = wdf['valid'].dt.year
            
            grouped = wdf.groupby("Year")

            # add years
            years = list(grouped.groups.keys())
            weather_data["year"] += years
            # add country
            weather_data["country"] += [country] * len(years)
            # add subdivision
            weather_data["subdivision"] += [subdiv] * len(years)

            # get mean of temp_c
            temp = grouped["tmpc"].mean().values.tolist()
            weather_data["temp_c"] += temp

            # get mean of humidity
            humid = grouped["relh"].mean().values.tolist()
            weather_data["rel_humid"] += humid

            # get mean of wind_speed
            wind = grouped["sknt"].mean().values.tolist()
            weather_data["wind_speed"] += wind

        
        # save to df and et_data
        output_data = pd.DataFrame(weather_data)
        print(output_data)

        path = os.path.join(csv_outpath_weather, "br_weather_2002_2022.csv")
        output_data.to_csv(path, index=False, doublequote=False)

    return

if __name__=="__main__":
    main()
