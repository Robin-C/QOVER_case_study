#!/bin/bash

git clone git@github.com:Robin-C/QOVER_case_study.git && cd QOVER_case_study
pip install virtualenv && virtualenv env && source env/bin/activate && pip install -r requirements.txt
python load/load_contracts.py & python load/load_policyholders.py & python load/load_tickets.py
cd dbt_qover && dbt deps && dbt snapshot && dbt run && dbt test
dbt docs generate && dbt docs serve