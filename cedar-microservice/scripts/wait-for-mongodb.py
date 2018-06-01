#!/usr/bin/python3
import os
import time
import urllib.parse

from pymongo import MongoClient


def check_db_connection(title_message, error_message):
    print(title_message + '...')
    uri = "mongodb://%s:%s@%s:%s/cedar" % (
        urllib.parse.quote(application_user), urllib.parse.quote(application_password), mongo_host, mongo_port)
    client = MongoClient(uri, connect=False, connectTimeoutMS=1000, serverSelectionTimeoutMS=1000)
    try:
        client.admin.command('ismaster')
    except Exception as e:
        print(error_message)
        print(e)
        return False
    finally:
        client.close()
    return True


def connect_with_app_user():
    return check_db_connection("Connecting to MongoDB with app user", "Connection not available yet")


def wait_for_mongodb():
    print("Wait for MongoDB application user connection ...")
    number_of_successes = 0
    number_of_failures = 0
    while number_of_successes < number_of_tries:
        if connect_with_app_user():
            number_of_successes += 1
        else:
            number_of_failures += 1
            number_of_successes = 0
        time.sleep(sleep_seconds)
        print("\tFailures:{},\tSuccesses:{}".format(number_of_failures, number_of_successes))


print("Reading environment variables")
mongo_host = os.environ.get('CEDAR_MONGO_HOST')
mongo_port = int(os.environ.get('CEDAR_MONGO_PORT'))
application_user = os.environ.get('CEDAR_MONGO_APP_USER_NAME')
application_password = os.environ.get('CEDAR_MONGO_APP_USER_PASSWORD')

number_of_tries = 7
sleep_seconds = 1

print("---- Server info ----")
print("MongoDB server host   :" + mongo_host)
print("MongoDB server port   :" + str(mongo_port))
print("Application user    :" + application_user)
# print("Application password:" + application_password)

print("Wait for MongoDB server to be available")

wait_for_mongodb()
