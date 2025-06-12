import os
import boto3
import yaml

def fetch_db_config_from_dynamodb(workspace_id: str) -> dict:
    aws_access_key_id = os.environ.get("AWS_ACCESS_KEY_ID")
    aws_secret_access_key = os.environ.get("AWS_SECRET_ACCESS_KEY")
    aws_region = os.environ.get("AWS_REGION")

    if not all([aws_access_key_id, aws_secret_access_key, aws_region]):
        raise Exception("Missing AWS credentials in environment variables")

    dynamodb = boto3.resource(
        "dynamodb",
        aws_access_key_id=aws_access_key_id,
        aws_secret_access_key=aws_secret_access_key,
        region_name=aws_region
    )
    table = dynamodb.Table("workspace-dbconn")

    response = table.get_item(Key={"workspace_id": workspace_id})
    if "Item" not in response:
        raise Exception(f"No DB config found for workspace: {workspace_id}")

    item = response["Item"]

    return {
        "provider": item["provider"],
        "database": item["database"],
        "username": item["username"],
        "password": item["password"],
        "host": item["host"],
        "port": int(item["port"]),
        "secure": item.get("secure", False),
    }

def write_dbt_profile(workspace_id: str, db_config: dict):
    profile_name = f"workspace_{workspace_id}"

    profiles = {
        profile_name: {
            "target": "dev",
            "outputs": {
                "dev": {
                    "type": db_config["provider"],
                    "schema": "default",  # change if needed
                    "database": db_config["database"],
                    "host": db_config["host"],
                    "user": db_config["username"],
                    "password": db_config["password"],
                    "port": db_config["port"],
                    "secure": db_config["secure"],
                }
            }
        }
    }

    dbt_dir = os.path.expanduser("~/.dbt")
    os.makedirs(dbt_dir, exist_ok=True)

    profiles_path = os.path.join(dbt_dir, "profiles.yml")
    with open(profiles_path, "w") as f:
        yaml.dump(profiles, f, default_flow_style=False)

    print(f"DBT profile for workspace '{workspace_id}' written to {profiles_path}")



if __name__ == "__main__":
    workspace_id = os.environ.get("WORKSPACE_ID")
    if not workspace_id:
        raise Exception("WORKSPACE_ID environment variable is not set")

    db_config = fetch_db_config_from_dynamodb(workspace_id)
    write_dbt_profile(workspace_id, db_config)
