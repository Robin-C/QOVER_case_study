# Qover Analytics Engineer Interview

This readme will help you get up and running.

Before getting started, you will need:

* Python (tested with 3.10)
* Git

You can either copy and paste the content of the `startup.sh` script into a file named `startup.sh` and run `source startup.sh` **OR** you can follow step by step below.

## 1. Clone repo and cd into it
`git clone git@github.com:Robin-C/QOVER_case_study.git && cd QOVER_case_study`

## 2. Create virtual environment, activate it and install python dependancies
`pip install virtualenv && python virtualenv env && . env/bin/activate && pip install -r requirements.txt`

## 3. Load csv data into bigquery using python scripts
`python load/load_contracts.py & python load/load_policyholders.py & python load/load_tickets.py`

## 4. Run dbt deps, snapshot, run and test
`cd dbt_qover && dbt deps && dbt snapshot && dbt run && dbt test`

All should be good!

## BI

You can visit the [lightdash dashboard](https://app.lightdash.cloud/projects/6fe464fe-bf62-4699-a116-5b8476651ee6/dashboards/f660d13a-cc69-4ce1-8daf-453dfbbcad07/view) for insights using the following credentials.

login: qover_lightdash@proton.me

password: 123