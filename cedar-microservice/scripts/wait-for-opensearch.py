#!/usr/bin/python3
import http.client
import os
import time


def check_opensearch_connection(title_message, error_message):
    print(title_message + '...')

    try:
        conn = http.client.HTTPConnection(opensearch_host, opensearch_port)
        conn.request("GET", "")
        status = conn.getresponse().status
        if status == 200:
            return True
        else:
            print(error_message)
            print("Status:" + str(status))
    except Exception as e:
        print(error_message)
        print(e)
    return False


def connect_to_opensearch():
    return check_opensearch_connection("Connecting to Opensearch", "Connection not available yet")


def wait_for_opensearch():
    print("Wait for REST API ...")
    number_of_successes = 0
    number_of_failures = 0
    while number_of_successes < number_of_tries:
        if connect_to_opensearch():
            number_of_successes += 1
        else:
            number_of_failures += 1
            number_of_successes = 0
        time.sleep(sleep_seconds)
        print("\tFailures:{},\tSuccesses:{}".format(number_of_failures, number_of_successes))


print("Reading environment variables")
opensearch_host = os.environ.get('CEDAR_OPENSEARCH_HOST')
opensearch_port = int(os.environ.get('CEDAR_OPENSEARCH_REST_PORT'))

number_of_tries = 5
sleep_seconds = 1

print("---- Server info ----")
print("Opensearch server host   :" + str(opensearch_host))
print("Opensearch server port   :" + str(opensearch_port))

print("Wait for Opensearch server to be available")

wait_for_opensearch()
