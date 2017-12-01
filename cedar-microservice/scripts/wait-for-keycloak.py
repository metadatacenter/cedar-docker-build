#!/usr/bin/python
import os

import time
import httplib


def check_keycloak_connection(title_message, error_message):
    print(title_message + '...')

    try:
        conn = httplib.HTTPConnection(keycloak_host, keycloak_port)
        conn.request("GET", "/auth/realms/CEDAR/.well-known/openid-configuration")
        status = conn.getresponse().status
        if status == 200:
            return True
        else:
            print error_message
            print "Status:" + str(status)
    except Exception as e:
        print error_message
        print e
    return False


def connect_to_keycloak():
    return check_keycloak_connection("Connecting to Keycloak", "Connection not available yet")


def wait_for_keycloak():
    print "Wait for openid-configuration location ..."
    number_of_successes = 0
    number_of_failures = 0
    while number_of_successes < number_of_tries:
        if connect_to_keycloak():
            number_of_successes += 1
        else:
            number_of_failures += 1
            number_of_successes = 0
        time.sleep(sleep_seconds)
        print "\tFailures:{},\tSuccesses:{}".format(number_of_failures, number_of_successes)


print "Reading environment variables"
keycloak_host = os.environ.get('CEDAR_KEYCLOAK_HOST')
keycloak_port = int(os.environ.get('CEDAR_KEYCLOAK_HTTP_PORT'))

number_of_tries = 5
sleep_seconds = 1

print "---- Server info ----"
print "Keycloak server host   :" + keycloak_host
print "Keycloak server port   :" + str(keycloak_port)

print "Wait for Keycloak server to be available"

wait_for_keycloak()