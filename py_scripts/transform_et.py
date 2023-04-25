"""
A script to clean and combine all extracted csvs
"""

import os
from config import countries, csv_outpath_et

import pandas as pd

def main():
    et_data = {
        "country": [],
        "subdivision": [],
        "max_et": [],    
        "median_et": [],   
        "mean_et": [],
        "year" : []
    }   

    # for each country 
    for country, info in countries.items():
        subdiv_code = info["subdiv_code"]

        # for each production csv
        et_source = os.path.join(csv_outpath_et, country)
        # get all csvs for production
        etcsv = os.listdir(et_source)

        for csv in etcsv:
            file = os.path.join(et_source, csv)
            etdf = pd.read_csv(file)

            # get subdiv
            code = csv[:2]
            subdiv = subdiv_code[code]

            # get year (yearly evapo is total kg/mm^2)
            etdf["Year"] = etdf["Date"].str[:4].apply(lambda x: str(int(x) - 1))
            grouped = etdf.groupby("Year")

            # add years
            years = list(grouped.groups.keys())
            et_data["year"] += years
            # add country
            et_data["country"] += [country] * len(years)
            # add subdivision
            et_data["subdivision"] += [subdiv] * len(years)

            # get mean of means
            avg = grouped["Mean"].mean().values.tolist()
            et_data["mean_et"] += avg

            # get median of medians
            med = grouped["Median"].median().values.tolist()
            et_data["median_et"] += med

            # get max of max
            high = grouped["Maximum"].max().values.tolist()
            et_data["max_et"] += high

        
        # save to df and et_data
        output_data = pd.DataFrame(et_data)
        print(output_data)

        path = os.path.join(csv_outpath_et, "br_et_2010_2020.csv")
        output_data.to_csv(path, index=False, doublequote=False)

    return

if __name__=="__main__":
    main()
