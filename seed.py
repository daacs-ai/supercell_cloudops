import sqlite3
import pandas as pd
import duckdb
import matplotlib.pyplot as plt

with open("./seeds/finops_test.sql", "r") as f:
    sql_script = f.read()

# Create or connect to a SQLite database
conn = sqlite3.connect("finops.db")
cursor = conn.cursor()
# Execute the SQL script
cursor.executescript(sql_script)
conn.commit()
conn.close()
# Connect to the SQLite DB created from your SQL script
conn = sqlite3.connect("finops.db")
# Load the entire table into a DataFrame
df = pd.read_sql_query("SELECT * FROM finops_test", conn)
conn.close()

con = duckdb.connect('supercell.duckdb')
con.execute("CREATE OR REPLACE TABLE supercell_usagelogs AS SELECT * FROM df")
con.close()