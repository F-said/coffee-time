pdf_inpath = "data\pdf\coffee"
csv_outpath_prod = "data\csv\production"
csv_outpath_growth = "data\csv\growth"

countries = {
    "Brazil": {
        "table_title": "Brazilian Coffee Production (Million 60-kg bags)",

        "bean_pages": [2, 3, 3], 
        "bean_table": [0, 0, 2],

        "tree_pages": [3, 4, 4],
        "tree_table": [0, 0, 0],
        
        "csv_bean": ["2013_br_prod", "2017_br_prod", "2022_br_prod"],
        "csv_tree": ["2013_br_growth", "2017_br_growth", "2022_br_growth"],

        "subdiv": ["Minas Gerais", "Espirito Santo", "Sao Paulo", "Parana"],
        "types": ["Arabica", "Robusta"]
    }
}