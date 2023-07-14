import os
import yaml
from google.oauth2 import service_account


def get_settings(env="dev"):
    cwd = os.getcwd()

    with open(f"{cwd}/load/config.yaml", "r") as file:
        data = yaml.load(file, Loader=yaml.SafeLoader)

    service_account_name = data[env]["service_account"]
    key_path = f"{cwd}/{service_account_name}"

    credentials = service_account.Credentials.from_service_account_file(key_path)

    return {
        "credentials": credentials,
        "gbq": {"dataset": data[env]["dataset"], "if_exists": data[env]["if_exists"]},
    }


if __name__ == "__main__":
    get_settings(env="dev")
