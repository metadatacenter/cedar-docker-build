#!/usr/bin/python3
import http.client
import os
import time


def check_elasticsearch_connection(title_message, error_message):
    print(title_message + '...')

    try:
        conn = http.client.HTTPConnection(elasticsearch_host, elasticsearch_port)
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


def connect_to_elasticsearch():
    return check_elasticsearch_connection("Connecting to Elasticsearch", "Connection not available yet")


def wait_for_elasticsearch():
    print("Wait for REST API ...")
    number_of_successes = 0
    number_of_failures = 0
    while number_of_successes < number_of_tries:
        if connect_to_elasticsearch():
            number_of_successes += 1
        else:
            number_of_failures += 1
            number_of_successes = 0
        time.sleep(sleep_seconds)
        print("\tFailures:{},\tSuccesses:{}".format(number_of_failures, number_of_successes))


print("Reading environment variables")
elasticsearch_host = os.environ.get('CEDAR_ELASTICSEARCH_HOST')
elasticsearch_port = int(os.environ.get('CEDAR_ELASTICSEARCH_REST_PORT'))

number_of_tries = 5
sleep_seconds = 1

print("---- Server info ----")
print("Elasticsearch server host   :" + elasticsearch_host)
print("Elasticsearch server port   :" + str(elasticsearch_port))

print("Wait for Elasticsearch server to be available")

wait_for_elasticsearch()
