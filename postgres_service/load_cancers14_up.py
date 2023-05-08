import re
import numpy as np
import pandas as pd
from sqlalchemy import create_engine

cancers = ["Colorectal",
           "Cervical",
           "Female breast",
           "Leukaemia",
           "Melanoma",
           "Prostate",
           "Lung",
           "Hodgkin",
           "Non-Hodgkin",
           "Myeloproliferative"]

data_locations = {
    "counts_male":{
        "usecols":"B:V",
        "skiprows":6,
        "nrows":12
    },
    "counts_female":{
        "usecols":"B:V",
        "skiprows":23,
        "nrows":12
    },
    "counts_total":{
        "usecols":"B:V",
        "skiprows":40,
        "nrows":12
    },
    "rates_male":{
        "usecols":"X:AR",
        "skiprows":6,
        "nrows":12
    },
    "rates_female":{
        "usecols":"X:AR",
        "skiprows":23,
        "nrows":12
    },
    "rates_total":{
        "usecols":"X:AR",
        "skiprows":40,
        "nrows":12
    }
}

def modify_col_names(col_names: list[str]) -> list[str]:
    mod_col_names = []
    for col_name in col_names:
        col_name = re.sub(".1$", "", col_name)
        col_name = re.sub("–", "_", col_name)
        col_name = re.sub(r"\+", "plus", col_name)
        if "Ethnic" in col_name:
            col_name = "ethnicity"
        if "Unnamed" in col_name:
            col_name = "ASR"
        if col_name[0].isdigit():
            col_name = "ages" + col_name
        if "Total" in col_name or "ASR" in col_name:
            col_name = "total_asr"
        col_name = col_name.lower()

        mod_col_names.append(col_name)
    return mod_col_names

source_file = "postgres_service/data/cancers14-16.xlsx"
engine = create_engine("postgresql+psycopg2://admin:root@localhost:5432/test_db")

for source_sheet in cancers:
    print("------------------------------")
    print(source_sheet)
    for key, value in data_locations.items():
        if source_sheet == "Non-Hodgkin":
            value = value.copy()
            value['skiprows'] = value['skiprows'] + 1

        source_data = pd.read_excel(
            io=source_file,
            sheet_name=source_sheet,
            **value
        )
        new_cols = modify_col_names(list(source_data.columns))
        source_data.columns = new_cols
        source_data["data_type"] = key
        source_data.replace("–", np.NaN, inplace=True)

        table_name = re.sub("-", "_", source_sheet)
        table_name = re.sub(" ", "_", table_name)
        source_data.to_sql(table_name.lower(), engine, index=False, if_exists="append", schema="health")
        print("\t-written:" + key)
