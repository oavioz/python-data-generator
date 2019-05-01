#!/bin/bash

## Create user service schema and csv files for each table

#mkdir -p   ~/Workspace/Dojo/user-service && cd $_
#cp -r ~/python-data-generator/* .

    psql "dbname=userservice host=localhost user=postgres password=postgres" -f user_service.sql
    # Create tenants csv files: python create_tenants_cvs_files.py <howManyFiles> <base_filename> <pathArray> <maxRows>
    python3 create_tenants_cvs_files.py 2 tenants  output/tenants/ 1000
    # Create subscriptions csv files
    python3 create_subscriptions_cvs_files.py 2 subscriptions  output/subscriptions/ 10000
    # Create roles permissions <SQL files>
    psql "dbname=userservice host=localhost user=postgres password=postgres" -f role_permissions.sql
    # Create subscription roles  - temp csv file(rows duplication)
    python3 create_subscription_roles_csv_files.py 2 subscription_roles_temp  output/subscription_roles_temp/ 10000
# Load csv file for each table
    # Load tenants csv files into tenants table: python users-service-data-pump.py <input path of csv files>
    python3 users-service-data-pump.py output/tenants
    # Load subscriptions csv files into subscriptions table
    python3 users-service-data-pump.py output/subscriptions
    # Load subscription_roles_temp csv files into subscription_roles_temp table
    python3 users-service-data-pump.py output/subscription_roles_temp/
    # Load to permamaent table subscription_roles
    psql "dbname=userservice host=localhost user=postgres password=postgres" -f subscription_roles.sql