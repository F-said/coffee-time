"""
A script to clean and combine all extracted csvs
"""

import os
from config import csv_outpath_et, csv_outpath_prod, csv_outpath_growth, \
                    csv_outpath_weather, csv_outpath_econ, final_data

import pandas as pd

def main():

    # get brazil data
    growth = os.path.join(csv_outpath_growth, "br_coffee_growth_2003_2023.csv")
    prod = os.path.join(csv_outpath_prod, "br_coffee_production_2003_2023.csv")
    et = os.path.join(csv_outpath_et, "br_et_2002_2020.csv")
    weather = os.path.join(csv_outpath_weather, "br_weather_2003_2020.csv")
    unemployment = os.path.join(csv_outpath_econ, "br_avgunemp_2012_2020.csv")

    gdf = pd.read_csv(growth)
    pdf = pd.read_csv(prod)
    edf = pd.read_csv(et)
    wdf = pd.read_csv(weather)
    unempdf = pd.read_csv(unemployment)

    join1 = pd.merge(pdf, gdf, how="left", on=["country", "year"])
    join2 = pd.merge(join1, edf, how="left", on=["country", "year", "subdivision"])

    join3 = pd.merge(join2, wdf, how="left", on=["country", "year", "subdivision"])
    join4 = pd.merge(join3, unempdf, how="left", on=["country", "year", "subdivision"])
    
    br_path = os.path.join(final_data, "br_final.csv")
    join4.to_csv(br_path, index=False)

    # get vietnam data
    


    return

if __name__=="__main__":
    main()
