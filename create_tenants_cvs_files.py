#!/usr/bin/env python
# encoding: utf-8
"""
create_tenants_files.py

Create a number of fake CVS files. 
Created by Oshik Avioz on 2019-04-05.
"""

import sys
import os
from faker import Faker
import csv
import random
fake = Faker()

def randomEnumerator(maxRows):
        howManyRows = random.randrange(0, int(maxRows))
        for currentRowNumber in range(0, howManyRows):
                yield currentRowNumber
    

def main(howManyFiles, base_filename, pathArray, maxRows):
        #filesGoIn = os.path.join(pathArray, '.'.join((base_filename)))
        #test = os.path.join(pathArray,base_filename)
        #full_path = os.path.join(pathArray, base_filename)
        filesGoIn = "".join(pathArray)
        # Create target Directory if don't exist
        if not os.path.exists(filesGoIn):
                os.mkdir(filesGoIn)
                print("Directory " , filesGoIn ,  " Created ")
        for currentNumber in range( 0, int(howManyFiles) ):
        
                f = open( filesGoIn + base_filename + "_" + str(currentNumber) + ".csv", 'w' )
                writer = csv.DictWriter(f, fieldnames= ["tenant_name","created_at", "updated_at", "is_active", "is_deleted"])
        
                for current in randomEnumerator(maxRows):

                        writer.writerow(  dict(tenant_name=fake.company() + "_" + str(current),
                        created_at=fake.past_datetime(start_date="-30d", tzinfo=None),
                        #created_at=fake.date_time_between(start_date="-40d", end_date="now", tzinfo=None),
                        updated_at=fake.past_date(),
                        is_active=random.choice([True, False]),
                        is_deleted=fake.boolean(chance_of_getting_true=100) )  )
                f.close()


if __name__ == '__main__':
        main( sys.argv[1], sys.argv[2], sys.argv[3],sys.argv[4])