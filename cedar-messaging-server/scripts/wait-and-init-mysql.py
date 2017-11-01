#!/usr/bin/python
import os

import MySQLdb
import time
from MySQLdb import OperationalError


def execute_db_code(title_message, code_to_execute, error_message):
    print(title_message + '...')
    connection = None
    try:
        connection = MySQLdb.connect(host=mysql_host, port=mysql_port, user=mysql_root_user, passwd=mysql_root_password)
        if code_to_execute is not None:
            code_to_execute(connection)
    except OperationalError as e:
        print error_message
        print e
        return False
    except:
        print "Unexpected error:", sys.exc_info()[0]
        return False
    finally:
        if connection is not None:
            connection.close()
    return True


def connect_with_root():
    return execute_db_code("Connecting with root user", None, "Connection not available yet")


def wait_for_root():
    print "Wait for root user connection ..."
    number_of_successes = 0
    number_of_failures = 0
    while number_of_successes < number_of_tries:
        if connect_with_root():
            number_of_successes += 1
        else:
            number_of_failures += 1
        time.sleep(sleep_seconds)
        print "\tFailures:{},\tSuccesses:{}".format(number_of_failures, number_of_successes)


def create_database_core(connection):
    cursor = connection.cursor()

    create_database_query = "CREATE DATABASE IF NOT EXISTS `{database}`"
    q1 = create_database_query.format(database=application_database)
    print q1
    cursor.execute(q1)


def create_database():
    return execute_db_code("Create database", create_database_core, "Error while creating application database")


def create_application_user_core(connection):
    cursor = connection.cursor()

    print "Dropping application user if exists ..."
    drop_user_query = "DROP USER IF EXISTS '{user}'@'{host}'"
    q1 = drop_user_query.format(user=application_user, host=localhost)
    q2 = drop_user_query.format(user=application_user, host=mysql_host)
    # print q1
    # print q2
    cursor.execute(q1)
    cursor.execute(q2)

    print "Creating application user ..."
    create_user_query = "CREATE USER '{user}'@'{host}' IDENTIFIED BY '{passwd}'"
    q1 = create_user_query.format(user=application_user, host=localhost, passwd=application_password)
    q2 = create_user_query.format(user=application_user, host=mysql_host, passwd=application_password)
    # print q1
    # print q2
    cursor.execute(q1)
    cursor.execute(q2)

    print "Granting all privileges to application user ..."
    grant_query = "GRANT ALL PRIVILEGES ON {database}.* TO '{user}'@'{host}'"
    q1 = grant_query.format(user=application_user, host=localhost, database=application_database)
    q2 = grant_query.format(user=application_user, host=mysql_host, database=application_database)
    # print q1
    # print q2
    cursor.execute(q1)
    cursor.execute(q2)


def create_application_user():
    return execute_db_code("Create application user", create_application_user_core,
                           "Error while creating application user")


print "Reading environment variables"
mysql_host = os.environ.get('CEDAR_MESSAGING_MYSQL_HOST')
mysql_port = int(os.environ.get('CEDAR_MESSAGING_MYSQL_PORT'))
mysql_root_user = "root"
mysql_root_password = os.environ.get('CEDAR_MYSQL_ROOT_PASSWORD')
application_user = os.environ.get('CEDAR_MESSAGING_MYSQL_USER')
application_password = os.environ.get('CEDAR_MESSAGING_MYSQL_PASSWORD')
application_database = os.environ.get('CEDAR_MESSAGING_MYSQL_DB')
localhost = '127.0.0.1'

number_of_tries = 5
sleep_seconds = 1

print "---- Server info ----"
print "MySQL server host   :" + mysql_host
print "MySQL server port   :" + str(mysql_port)
print "Root user           :" + mysql_root_user
# print "Root password       :" + mysql_root_password
print "Application user    :" + application_user
# print "Application password:" + application_password
print "Application database:" + application_database

print "Wait for MySQL server to be available"

wait_for_root()
create_database()
create_application_user()
