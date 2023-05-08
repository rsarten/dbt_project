import re
import pandas as pd
from sqlalchemy import create_engine

data_locations = {
    "counts_total":{
        "usecols":"A:U",
        "skiprows":4,
        "nrows":24
    },
    "counts_maori":{
        "usecols":"A:U",
        "skiprows":36,
        "nrows":24
    },
    "counts_non_maori":{
        "usecols":"A:U",
        "skiprows":68,
        "nrows":24
    },
    "rates_total":{
        "usecols":"W:AR",
        "skiprows":4,
        "nrows":24
    },
    "rates_maori":{
        "usecols":"W:AR",
        "skiprows":36,
        "nrows":24
    },
    "rates_non_maori":{
        "usecols":"W:AR",
        "skiprows":68,
        "nrows":24
    }
}

def modify_col_names(col_names: list[str]) -> list[str]:
    mod_col_names = []
    for col_name in col_names:
        col_name = re.sub("–", "_", col_name)
        col_name = re.sub(r"\+", "plus", col_name)
        if "Unnamed" in col_name:
            col_name = "sex"
        if "Cancer" in col_name:
            col_name = "cancer"
        if col_name[0].isdigit():
            col_name = "ages" + col_name

        mod_col_names.append(col_name)
    return mod_col_names

source_file = "data/cancers11-13.xlsx"
source_sheets = ["2011_Registrations", "2012_Registrations", "2013_Registrations"]

for source_sheet in source_sheets:
    source_year = source_sheet[0:4]
    data = {}
    for key, value in data_locations.items():
        source_data = pd.read_excel(
            io=source_file,
            sheet_name=source_sheet,
            **value
        )
        new_cols = modify_col_names(list(source_data.columns))
        source_data.columns = new_cols
        source_data["year"] = int(source_year)
        data[key] = source_data
    
    engine = create_engine("postgresql+psycopg2://admin:root@localhost:5432/test_db")

    for key, value in data.items():
        value.to_sql(key, engine, index=False, if_exists="append", schema="health")
