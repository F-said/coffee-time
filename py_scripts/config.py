pdf_inpath = "data\pdf\coffee"

csv_outpath_prod = "data\csv\production"
csv_outpath_growth = "data\csv\growth"
csv_outpath_et = "data\csv\et"
csv_outpath_weather = "data\csv\weather"
csv_outpath_econ = "data\csv\economy"

final_data = "data\csv\ml_data"

countries = {
    "Brazil": {
        "table_title": "Brazilian Coffee Production (Million 60-kg bags)",

        "bean_pages": [4, 2, 3, 3], 
        "bean_table": [0, 0, 0, 2],

        "tree_pages": [5, 3, 4, 4],
        "tree_table": [0, 0, 0, 0],
        
        "csv_bean": ["2008_br_prod", "2013_br_prod", "2017_br_prod", "2022_br_prod"],
        "csv_tree": ["2008_br_growth", "2013_br_growth", "2017_br_growth", "2022_br_growth"],

        "subdiv": ["Minas Gerais", "Espirito Santo", "Sao Paulo", "Parana"],
        "types": ["Arabica", "Robusta"],

        "subdiv_code": {
            "mg": "Minas Gerais",
            "es": "Espirito Santo",
            "sp": "Sao Paulo",
            "pa": "Parana"
        }
    }
}