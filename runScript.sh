#!/bin/bash

## Create user service schema and csv files for each table

mkdir -p   ~/Workspace/Dojo/user-service && cd $_

    psql "dbname=userservice host=localhost user=postgres password=postgres" -f ~/Workspace/Dojo/user-service/user_service.sql
    # Create tenants csv files: python create_tenants_cvs_files.py <howManyFiles> <base_filename> <pathArray> <maxRows>
    python create_tenants_cvs_files.py 2 tenants  ~/Workspace/Dojo/user-service/output/tenants/ 1000
    # Create subscriptions csv files
    python create_subscriptions_cvs_files.py 2 subscriptions  ~/Workspace/Dojo/user-service/output/subscriptions/ 10000
    # Create roles permissions <SQL files>
    psql "dbname=userservice host=localhost user=postgres password=postgres" -f ~/Workspace/Dojo/user-service/role_permissions.sql
    # Create subscription roles  - temp csv file(rows duplication)
    python create_subscription_roles_csv_files.py 2 subscription_roles_temp  ~/Workspace/Dojo/user-service/output/subscription_roles_temp/ 10000
# Load csv file for each table
    # Load tenants csv files into tenants table: python users-service-data-pump.py <input path of csv files>
    python users-service-data-pump.py ~/Workspace/Dojo/user-service/output/tenants
    # Load subscriptions csv files into subscriptions table
    python users-service-data-pump.py ~/Workspace/Dojo/user-service/output/subscriptions
    # Load subscription_roles_temp csv files into subscription_roles_temp table
    python users-service-data-pump.py ~/Workspace/Dojo/user-service/output/subscription_roles_temp/
    # Load to permamaent table subscription_roles
    psql "dbname=userservice host=localhost user=postgres password=postgres" -f ~/Workspace/Dojo/user-service/subscription_roles.sql