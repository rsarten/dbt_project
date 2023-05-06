import pandas as pd
from sqlalchemy import create_engine

source_file = "data/cancers11-13.xlsx"
source_sheet = "2011_Registrations"
source_year = source_sheet[0:4]

data_locations = {
    "total_number":{
        "usecols":"A:U",
        "skiprows":4,
        "nrows":24
    },
    "maori_number":{
        "usecols":"A:U",
        "skiprows":36,
        "nrows":24
    },
    "non_maori_number":{
        "usecols":"A:U",
        "skiprows":68,
        "nrows":24
    },
    "total_rate":{
        "usecols":"W:AR",
        "skiprows":4,
        "nrows":24
    },
    "maori_rate":{
        "usecols":"W:AR",
        "skiprows":36,
        "nrows":24
    },
    "non_maori_rate":{
        "usecols":"W:AR",
        "skiprows":68,
        "nrows":24
    }
}

data = {}
for key, value in data_locations.items():
    source_data = pd.read_excel(
        io=source_file,
        sheet_name=source_sheet,
        **value
    )
    source_data["year"] = int(source_year)
    data[key] = source_data
 
engine = create_engine("postgresql+psycopg2://admin:root@localhost:5432/test_db")

for key, value in data.items():
    value.to_sql(key, engine, index=False, if_exists="append", schema="health")
