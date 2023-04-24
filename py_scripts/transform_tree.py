"""
A script to clean and combine all extracted csvs
"""

import os
from config import countries, csv_outpath_prod, csv_outpath_growth

import pandas as pd
import numpy as np
import regex as re

def main():
    tree_data = {
        "country": [],
        "nonbear_mill_trees": [],
        "bear_mill_trees": [], 
        "nonbear_thous_hect": [],    
        "bear_thous_hect": [],   
        "year": []
    }   

    # for each country 
    for country, _ in countries.items():
        # for each production csv
        tree_source = os.path.join(csv_outpath_growth,country)
        # get all csvs for production
        tcsvs = os.listdir(tree_source)

        # for each growth csv
        for csv in tcsvs:
            file = os.path.join(tree_source, csv)
            tdf = pd.read_csv(file)
            
            # check if csv needs transformations
            if tdf.columns[0] == "trees/hectare)":
                # remove erroneous header
                new_header = tdf.iloc[0].tolist()
                tdf = tdf[1:]
                tdf.columns = new_header

                # reset index and drop former
                tdf.reset_index(inplace=True, drop=True)
                
            # remove source
            tdf = tdf[:-1]
            
            # remove commas to prevent unexpected splitting
            tdf = tdf.apply(lambda x: x.str.replace(",", ""))

            # replace spaces to prevent unexpected splitting
            tdf.iloc[0, 0] = tdf.iloc[0, 0][0:10].replace(" ", "-") + tdf.iloc[0, 0][10:]
            tdf.iloc[3, 0] = tdf.iloc[3, 0][0:10].replace(" ", "-") + tdf.iloc[3, 0][10:]

            # split columns and trasnfrom
            # TODO: should be modularized (same as transform_bean)
            orig_col = tdf.columns[0]
            tdf.rename(columns={orig_col:'handle'}, inplace=True)

            # split column names
            new_cols = orig_col.split()
            # join together each string after first
            joined_cols = ["category"]
            joined_cols += [new_cols[c] + " " + new_cols[c+1] for c in range(0, len(new_cols), 2)]

            # split each value into a corre. column according to spacing
            tdf[joined_cols] = tdf.handle.str.split(expand=True)

            # drop handle
            tdf.drop(columns=["handle"], inplace=True)

             # get years (since years the same across prod, no need to loop)
            indices = tdf.columns.tolist()
            indices.remove("category")
             # convert all market-years to simple end-of-year & append
            years = ["20" + y[-2:] for y in indices]

            # get bearing & non tree data
            nonbeart = tdf.iloc[1, :].tolist()
            nonbeart.remove("Non-Bearing")
            nonbeart = [int(v) for v in nonbeart]

            tree_data["nonbear_mill_trees"] += nonbeart

            beart = tdf.iloc[2, :].tolist()
            beart.remove("Bearing")
            beart = [int(v) for v in beart]

            tree_data["bear_mill_trees"] += beart

            # get bearing & non hectare area data
            nonbearh = tdf.iloc[4, :].tolist()
            nonbearh.remove("Non-Bearing")
            nonbearh = [int(v) for v in nonbearh]

            tree_data["nonbear_thous_hect"] += nonbearh

            bearh = tdf.iloc[5, :].tolist()
            bearh.remove("Harvested")
            bearh = [int(v) for v in bearh]

            tree_data["bear_thous_hect"] += bearh

            # append years
            tree_data["year"] += years
            # append country
            tree_data["country"] += [country] * len(years)

            # save to df and tree_data
            output_data = pd.DataFrame(tree_data)

            path = os.path.join(csv_outpath_growth, "br_coffee_growth_2010_2023.csv")
            output_data.to_csv(path, index=False, doublequote=False)

    return

if __name__=="__main__":
    main()
