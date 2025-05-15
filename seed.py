import sqlite3
import pandas as pd
import duckdb
import matplotlib.pyplot as plt

with open("./seeds/finops_test.sql", "r") as f:
    sql_script = f.read()



# Add DROP TABLE IF EXISTS before executing the SQL script
drop_table_sql = "DROP TABLE IF EXISTS finops_test;"

# Create or connect to a SQLite database
conn = sqlite3.connect("finops.db")
cursor = conn.cursor()

# Execute the SQL script
cursor.executescript(drop_table_sql+sql_script)
conn.commit()
# conn.close()
df = pd.read_sql_query("SELECT * FROM finops_test", conn)
conn.close()


# Drop and recreate table in DuckDB
con = duckdb.connect('supercell.duckdb')
# Register the DataFrame as a DuckDB view and create or replace table from it
con.register("df_view", df)
con.execute("CREATE OR REPLACE TABLE supercell_usagelogs AS SELECT * FROM df_view")

# Export the DuckDB table to CSV
con.execute("COPY supercell_usagelogs TO 'output.csv' (HEADER, DELIMITER ',');")
con.close()