import os
import yaml
from google.oauth2 import service_account
import pandas as pd

from bq_settings import get_settings


def load_tickets(filepath, settings):
    # bq settings
    credentials = settings.get("credentials")
    project_id = credentials.project_id
    dataset = settings["gbq"].get("dataset")
    if_exists = settings["gbq"].get("if_exists")
    table = "src_tickets"
    dataset_table = f"{dataset}.{table}"

    # load csv
    tickets_df = pd.read_csv(filepath, delimiter=sep)

    # send it to bq
    try:
        tickets_df.to_gbq(
            dataset_table,
            project_id=project_id,
            if_exists=if_exists,
            credentials=credentials,
        )
    except:
        raise Exception("Error loading tickets.csv")
    
    return True


if __name__ == "__main__":
    settings = get_settings()
    # csv
    cwd = os.getcwd()
    filename = "tickets.csv"
    sep = ","
    filepath = f"{cwd}/data/{filename}"

    load_tickets(filepath, settings)
