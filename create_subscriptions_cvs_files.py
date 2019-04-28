#!/usr/bin/env python
# encoding: utf-8
"""
create_cvs_files.py

Create a number of fake CVS files. These files have an arbitrary length (from
5 lines to 600), and each have 6 columns.

Requires python-faker (http://github.com/threadsafelabs/python-faker)

Created by Ryan Wilcox on 2010-06-27.
Please consider this code as part of the public domain
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
                writer = csv.DictWriter(f, fieldnames= ["tenant_id","first_name", "last_name", "email", "password","created_at", "updated_at", "is_active", "is_deleted"])
        
                for current in randomEnumerator(maxRows):

                        writer.writerow(  dict( tenant_id=fake.random_int(1, int(maxRows)),
                        first_name=fake.first_name(),
                        last_name=fake.last_name(),
                        email=fake.email() + "_" + str(current),
                        password=fake.password(),
                        created_at=fake.past_datetime(start_date="-30d", tzinfo=None),
                        #created_at=fake.date_time_between(start_date="-40d", end_date="now", tzinfo=None),
                        updated_at=fake.past_date(),
                        is_active=random.choice([True, False]),
                        is_deleted=fake.boolean(chance_of_getting_true=100) )  )
                f.close()


if __name__ == '__main__':
	main( sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4] )