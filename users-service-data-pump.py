import os
import subprocess
import sys

path = sys.argv[1]


def loadfile(file):
    print ("loading file: " + file)

    #host = "#"

    query = "psql \"dbname=userservice host=localhost user=postgres password=postgres\""
    #query = "psql " + '"dbname=rbac_multitenants host=127.0.0.1 user=postgres password=postgres port=5432" COPY'

    try:
        if "subscriptions" in file:
            query += " -c \" COPY subscriptions (tenant_id,first_name,last_name,email,password,created_at,updated_at,is_active,is_deleted) FROM '" + file + "' WITH (FORMAT csv);\""
        elif "tenants" in file:
            query += " -c \" COPY tenants (tenant_name,created_at,updated_at,is_active,is_deleted) FROM '" + file + "' WITH (FORMAT csv);\""
        elif "role_permissions" in file:
            query += " -f role_permissions.sql"
        elif "subscription_roles" in file:
            query += " -c \" COPY subscription_roles_temp (subscription_id,role_permissions_id,permission_extention,created_at,updated_at,is_deleted) FROM '" + file + "' WITH (FORMAT csv);\""
        else:
            print ("could not find parser")

        #query += " FROM '" + file + "' WITH (FORMAT csv);\""

        print ("Going to run: " + query)

        process = subprocess.Popen(query, shell=True)
        exitCode = process.wait()
        if exitCode == 0:
            print ("Done loading " + file)
        else:
            print ("Still working!")

    except Exception as inst:
        print("failed loading csv with following error: " + inst)
    

#print (path)
paths = [os.path.join(path, fn) for fn in next(os.walk(path))[2]]


print ("Path name " + path)
for file in paths:
    print ("Calling load on: " + file)
    loadfile(file)

