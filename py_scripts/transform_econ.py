"""
A script to clean and combine all extracted csvs
"""

import os
from config import countries, csv_outpath_econ
import datetime

import pandas as pd

def main():
    # for each country 
    for country, _ in countries.items():
        
        econ_source = os.path.join(csv_outpath_econ, country, "br_perc_unemp.csv")
        # get all csvs for production
        ecsv = pd.read_csv(econ_source)
        
        # compute average for each row
        new_df = ecsv.copy()
        new_df["avg_unemp_perc"] = new_df.iloc[:, 2:6].mean(axis=1)
        
        new_df.drop(columns=["1st_quarter", "2nd_quarter", "3rd_quarter", "4th_quarter"], inplace=True)
        
        path = os.path.join(csv_outpath_econ, "br_avgunemp_2012_2020.csv")
        new_df.to_csv(path, index=False, doublequote=False)

    return

if __name__=="__main__":
    main()
