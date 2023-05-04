import pandas as pd
from sqlalchemy import create_engine

iris = pd.read_csv("iris.csv", header=None)

engine = create_engine("postgresql+psycopg2://admin:root@localhost:5432/test_db")

iris.rename(
    columns={
        0: "sepal_length",
        1: "sepal_width",
        2: "petal_length",
        3: "petal_width",
        4: "iris_class",
    },
    inplace=True,
)

iris.to_sql("iris", engine, index=False, if_exists="replace")
