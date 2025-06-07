import sqlite3
import pandas as pd
import matplotlib.pyplot as plt
import clickhouse_connect

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

df = pd.read_sql_query("SELECT * FROM finops_test", conn)
conn.close()

print(df.head())
print(df.dtypes)



import clickhouse_connect



# Extract connection details
CLICKHOUSE_CLOUD_HOSTNAME = "3.108.206.137"
CLICKHOUSE_CLOUD_USER = "default"
CLICKHOUSE_CLOUD_PASSWORD = "default"
CLICKHOUSE_CLOUD_DB = "rightsize"
PORT = 8123
# Establish ClickHouse client connection
client = clickhouse_connect.get_client(
    host=CLICKHOUSE_CLOUD_HOSTNAME,
    username=CLICKHOUSE_CLOUD_USER,
    password=CLICKHOUSE_CLOUD_PASSWORD,
    database=CLICKHOUSE_CLOUD_DB,
    port=PORT,
    secure=False
)
# Test the connection with a simple query
client.query('SELECT 1')
print("✅ Connection to ClickHouse established successfully!")


# Sanitize column names
df.columns = df.columns.str.replace('/', '_')

# Ensure types are correct
df['amortized_cost'] = pd.to_numeric(df['amortized_cost'], errors='coerce')
df['lineItem_UsageAmount'] = pd.to_numeric(df['lineItem_UsageAmount'], errors='coerce')
df['lineItem_UsageStartDate'] = pd.to_datetime(df['lineItem_UsageStartDate'])
df['lineItem_UsageEndDate'] = pd.to_datetime(df['lineItem_UsageEndDate'])


client.command("DROP TABLE IF EXISTS aws_cost_usage")

# Create table
create_table_query = """
CREATE TABLE IF NOT EXISTS aws_cost_usage (
    LinkedAccountId String,
    bill_PayerAccountId String,
    lineItem_UsageStartDate DateTime,
    lineItem_UsageEndDate DateTime,
    lineItem_UsageAmount Float64,
    lineItem_Operation String,
    pricing_PricingModel String,
    resourceTags_TagKeys String,
    resourceTags_TagValues String,
    product_Region String,
    product_ServiceCode String,
    product_InstanceType String,
    amortized_cost Float64,
    product_Description String
) ENGINE = MergeTree()
ORDER BY (lineItem_UsageStartDate, product_ServiceCode)
"""
client.command(create_table_query)

batch_size = 10000
for i in range(0, len(df), batch_size):
    batch = df.iloc[i:i + batch_size]
    # client.insert('aws_cost_usage', batch.values.tolist)
    client.insert(
        'aws_cost_usage',
        batch.values.tolist(),                    # ← Call .tolist()
        column_names=list(batch.columns)          # ← Ensure column names match
    )