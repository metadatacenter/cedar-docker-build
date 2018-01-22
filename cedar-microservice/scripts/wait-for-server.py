#!/usr/bin/python
import os

import time
import httplib
import sys


def check_server_connection(title_message, error_message):
    print(title_message + '...')

    try:
        conn = httplib.HTTPConnection(server_host, server_port)
        conn.request("GET", "/healthcheck")
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


def connect_to_server():
    return check_server_connection("Connecting to CEDAR " + server_name + " Server", "Connection not available yet")


def wait_for_server():
    print "Wait for CEDAR Server ..."
    number_of_successes = 0
    number_of_failures = 0
    while number_of_successes < number_of_tries:
        if connect_to_server():
            number_of_successes += 1
        else:
            number_of_failures += 1
            number_of_successes = 0
        time.sleep(sleep_seconds)
        print "\tFailures:{},\tSuccesses:{}".format(number_of_failures, number_of_successes)


print "Reading environment variables"
server_host = os.environ.get('CEDAR_MICROSERVICE_HOST')
server_name = sys.argv[1]
server_port = int(sys.argv[2])

number_of_tries = 5
sleep_seconds = 1

print "---- Server info ----"
print "CEDAR server host   :" + server_host
print "CEDAR server name   :" + server_name
print "CEDAR server port   :" + str(server_port)

print "Wait for CEDAR Server server to be available"

wait_for_server()