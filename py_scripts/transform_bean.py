"""
A script to clean and combine all extracted csvs
"""

import os
from config import countries, csv_outpath_prod

import pandas as pd
import regex as re

def main():
    bean_data = {
        "country": [],
        "subdivision": [],
        "type": [],
        "million_60kgs_bag": [],       
        "year": []
    }

    # for each country 
    for country, info in countries.items():
        subdivs = info["subdiv"]
        ctypes = info["types"]
        
        # for each production csv
        country_source = os.path.join(csv_outpath_prod ,country)
        # get all csvs for production
        csvs = os.listdir(country_source)

        for csv in csvs:
            file = os.path.join(country_source, csv)
            df = pd.read_csv(file)
            
            # check if csv needs transformations
            if df.iloc[:, 0].name != "State/Variety":
                # get former column name, rename for convenience
                # TODO: modularize this
                orig_col = df.columns[0]
                df.rename(columns={orig_col:'handle'}, inplace=True)

                # split column names
                new_cols = orig_col.split()
                # join together each string after first
                joined_cols = []
                joined_cols += [new_cols[0]]
                joined_cols += [new_cols[c] + " " + new_cols[c+1] for c in range(1, len(new_cols), 2)]

                # transform Minas Gerais, Espirito Santo, & Sao Paulo to prevent accidental splitting
                df.iloc[0, 0] = df.iloc[0, 0][0:12].replace(" ", "") + df.iloc[0, 0][12:]
                df.iloc[4, 0] = df.iloc[4, 0][0:14].replace(" ", "") + df.iloc[4, 0][14:]
                df.iloc[7, 0] = df.iloc[7, 0][0:9].replace(" ", "") + df.iloc[7, 0][9:]

                # set new split column names into split values
                df[joined_cols] = df.handle.str.split(expand=True)

                # fix spacing in Minas Gerais, Espirito Santo, & Sao Paul
                df["State/Variety"] = df["State/Variety"].apply(lambda x: re.sub(r"(\w)([A-Z])", r"\1 \2", x))

                # drop handle
                df.drop(columns=["handle"], inplace=True)

            # ignore every row past "Others"
            ign_df = df.iloc[:9, :]
            # ignore regions
            new_df = ign_df[(ign_df["State/Variety"].isin(subdivs)) | (ign_df["State/Variety"].isin(ctypes))]

            # bring state/variety to front if not already
            if new_df.iloc[:, 0].name != "State/Variety":
                new_df.insert(0, 'State/Variety', new_df.pop("State/Variety"))
        
            # get years (since years the same across prod, no need to loop)
            indices = new_df.columns.tolist()
            indices.remove("State/Variety")
             # convert all market-years to simple end-of-year & append
            years = ["20" + y[-2:] for y in indices]

            # create new row for each sub-div & year
            for div in subdivs:
                # if at EP, get arabica and robusta 
                if div == "Espirito Santo":
                    # get Arabica
                    vals1 = new_df[new_df["State/Variety"] == "Arabica"].iloc[0, :].tolist()
                    vals1.remove("Arabica")

                    vals1 = [float(v) for v in vals1]
                
                    # append country
                    bean_data["country"] += [country] * len(years)
                    # append type
                    bean_data["type"] += ["Arabica"] * len(years)
                    # append subdiv
                    bean_data["subdivision"] += [div] * len(years)
                    # append years
                    bean_data["year"] += years

                    # get Robusta
                    vals2 = new_df[new_df["State/Variety"] == "Robusta"].iloc[0, :].tolist()
                    vals2.remove("Robusta")

                    vals2 = [float(v) for v in vals2]
                    
                    # append country
                    bean_data["country"] += [country] * len(years)
                    # append type
                    bean_data["type"] += ["Robusta"] * len(years)
                    # append subdiv
                    bean_data["subdivision"] += [div] * len(years)
                    # append years
                    bean_data["year"] += years

                    vals = vals1 + vals2
                else:
                    # get values
                    vals = new_df[new_df["State/Variety"] == div].iloc[0, :].tolist()
                    vals.remove(div)

                    # convert all to int
                    vals = [float(v) for v in vals]

                    # append country
                    bean_data["country"] += [country] * len(years)
                    # append type (by default Arabica)
                    bean_data["type"] += ["Arabica"] * len(years)
                    # append subdiv
                    bean_data["subdivision"] += [div] * len(years)
                    # append years to list
                    bean_data["year"] += years 

                # append values to list
                bean_data["million_60kgs_bag"] += vals

                # remove predicted values post (most-updated csv has actual values) 
                # TODO: manual

        # save to df and write
        output_data = pd.DataFrame(bean_data)
        path = os.path.join(csv_outpath_prod, "br_coffee_production_2003_2023.csv")
        output_data.to_csv(path, index=False, doublequote=False)

    return

if __name__=="__main__":
    main()
