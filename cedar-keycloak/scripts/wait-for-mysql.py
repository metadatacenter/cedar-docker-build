#!/usr/bin/python
import os

import MySQLdb
import sys
import time
from MySQLdb import OperationalError


def connect_with_root():
    print "Connecting with root user"
    connection = None
    try:
        connection = MySQLdb.connect(host=mysql_host, port=mysql_port, user=mysql_root_user, passwd=mysql_root_passwd)
    except OperationalError as e:
        print "Connection not available yet"
        return False
    except:
        print "Unexpected error:", sys.exc_info()[0]
        return False
    finally:
        if connection is not None:
            connection.close()
    return True


def wait_for_root():
    print "Wait for root user connection"
    number_of_successes = 0
    number_of_failures = 0
    while number_of_successes < number_of_tries:
        if connect_with_root():
            number_of_successes += 1
        else:
            number_of_failures += 1
        time.sleep(sleep_seconds)
        print "\tFailures:{},\tSuccesses:{}".format(number_of_failures, number_of_successes)


def create_database():
    print "Create database"
    connection = None
    try:
        connection = MySQLdb.connect(host=mysql_host, port=mysql_port, user=mysql_root_user, passwd=mysql_root_passwd)
        cursor = connection.cursor()

        create_database_query = "CREATE DATABASE IF NOT EXISTS `%(database)s`"
        q1 = create_database_query % {'database': mysql_application_database}
        print q1
        cursor.execute(q1)

    except OperationalError as e:
        print "Error while creating application database"
        print e
    except:
        print "Unexpected error:", sys.exc_info()[0]
    finally:
        if connection is not None:
            connection.close()


def create_application_user():
    print "Create application user"
    connection = None
    try:
        connection = MySQLdb.connect(host=mysql_host, port=mysql_port, user=mysql_root_user, passwd=mysql_root_passwd)
        cursor = connection.cursor()

        drop_user_query = "DROP USER IF EXISTS '%(user)s'@'%(host)s'"
        q1 = drop_user_query % {'user': mysql_application_user, 'host': '127.0.0.1'}
        q2 = drop_user_query % {'user': mysql_application_user, 'host': mysql_host}
        print q1
        print q2
        cursor.execute(q1)
        cursor.execute(q2)

        create_user_query = "CREATE USER '%(user)s'@'%(host)s' IDENTIFIED BY '%(pass)s'"
        q1 = create_user_query % {'user': mysql_application_user, 'host': '127.0.0.1', 'pass': mysql_application_passwd}
        q2 = create_user_query % {'user': mysql_application_user, 'host': mysql_host, 'pass': mysql_application_passwd}
        print q1
        print q2
        cursor.execute(q1)
        cursor.execute(q2)

        grant_query = "GRANT ALL PRIVILEGES ON %(database)s.* TO '%(user)s'@'%(host)s'"
        q1 = grant_query % {'user': mysql_application_user, 'host': 'localhost', 'database': mysql_application_database}
        q2 = grant_query % {'user': mysql_application_user, 'host': mysql_host, 'database': mysql_application_database}
        print q1
        print q2
        cursor.execute(q1)
        cursor.execute(q2)

    except OperationalError as e:
        print "Error while creating application user"
        print e
    except:
        print "Unexpected error:", sys.exc_info()[0]
    finally:
        if connection is not None:
            connection.close()

print "Reading environment variables"
mysql_host = os.environ.get('CEDAR_KEYCLOAK_MYSQL_HOST')
mysql_port = int(os.environ.get('CEDAR_KEYCLOAK_MYSQL_PORT'))
mysql_root_user = "root"
mysql_root_passwd = os.environ.get('CEDAR_MYSQL_ROOT_PASSWORD')
mysql_application_user = os.environ.get('CEDAR_KEYCLOAK_MYSQL_USER')
mysql_application_passwd = os.environ.get('CEDAR_KEYCLOAK_MYSQL_PASSWORD')
mysql_application_database = os.environ.get('CEDAR_KEYCLOAK_MYSQL_DB')

number_of_tries = 5
sleep_seconds = 1

print "Server info:"
print "Host:" + mysql_host
print "Port:" + str(mysql_port)

print "Wait for MySQL server to be available"

wait_for_root()
create_database()
create_application_user()
