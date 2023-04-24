"""
A script to clean and combine all extracted csvs
"""

import os
from config import countries, csv_outpath_prod, csv_outpath_growth

import pandas as pd

def main():

    data = {
        "country": [],
        "region": [],
        "year": [],
        "prod": [],
        "growth": []
    }
    
    # for each country 
    for country, info in countries.items():
        country_source = os.path.join(csv_outpath_prod ,country)

        # get all csvs for production
        csvs = os.listdir(country_source)

        for csv in csvs:
            file = os.path.join(country_source, csv)
            df = pd.read_csv(file)
            
            # check if csv was read correctly
            if df.iloc[:, 0] == "State/Variety":
            # otherwise transform
            

    # initialize dataframe
    pd.DataFrame()


    return

if __name__=="__main__":
    main()
