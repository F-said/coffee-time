"""
A script to analyze all pertinent PDF's and convert into CSV's
"""

from tabula import read_pdf

import os
from config import pdf_inpath, \
                    csv_outpath_prod, csv_outpath_growth, \
                    countries

def main():
    for country, info in countries.items():
        country_source = os.path.join(pdf_inpath ,country)
        pdfs = os.listdir(country_source)

        # TODO: preferably, I should be finding tables by name, not hard-coded postition
        # title = info["table_title"]
        bean_pages = info["bean_pages"]
        bean_ind = info["bean_table"]
        csv_bean = info["csv_bean"]

        growth_pages = info["tree_pages"]
        growth_ind = info["tree_table"]
        csv_growth = info["csv_tree"]

        file_ind = 0
        for file in pdfs:
            fp = os.path.join(country_source, file)

            print("Reading PDF for coffee production", fp)
            # select all tables on page where production table is located
            bean_dfs = read_pdf(fp, pages=str(bean_pages[file_ind]))
            # narrow selection to singular table
            bdf = bean_dfs[bean_ind[file_ind]]

            # replace header with first row
            header = bdf.iloc[0]
            bdf = bdf[1:]
            bdf.columns = header
            
            # save extracted bean df
            bean_name = os.path.join(csv_outpath_prod, country, csv_bean[file_ind])
            bdf.to_csv(f"{bean_name}.csv", doublequote=False, index=False)

            print("Reading PDF for tree growth", fp)
             # select all tables on page where growth table is located
            tree_dfs = read_pdf(fp, pages=str(growth_pages[file_ind]))
            # narrow selection to singular table
            tdf = tree_dfs[growth_ind[file_ind]]

            # replace header with first row
            header = tdf.iloc[0]
            tdf = tdf[1:]
            tdf.columns = header

            # save extracted tree df
            tree_name = os.path.join(csv_outpath_growth, country, csv_growth[file_ind])
            tdf.to_csv(f"{tree_name}.csv", doublequote=False, index=False)

            file_ind += 1

    return

if __name__=="__main__":
    main()
