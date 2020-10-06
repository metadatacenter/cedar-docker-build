#!/usr/bin/python3
import os
import time
from base64 import b64encode

import http.client


def check_neo4j_connection(title_message, error_message):
    print(title_message + '...')

    try:
        user_and_pass = b64encode((neo4j_user + ":" + neo4j_password).encode('ascii')).decode("ascii")
        headers = {'Authorization': 'Basic %s' % user_and_pass}
        conn = http.client.HTTPConnection(neo4j_host, neo4j_port)
        conn.request("GET", "/db/data/", headers=headers)
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


def connect_to_neo4j():
    return check_neo4j_connection("Connecting to Neo4j", "Connection not available yet")


def wait_for_neo4j():
    print("Wait for Neo4j ...")
    number_of_successes = 0
    number_of_failures = 0
    while number_of_successes < number_of_tries:
        if connect_to_neo4j():
            number_of_successes += 1
        else:
            number_of_failures += 1
            number_of_successes = 0
        time.sleep(sleep_seconds)
        print("\tFailures:{},\tSuccesses:{}".format(number_of_failures, number_of_successes))


print("Reading environment variables")
neo4j_host = os.environ.get('CEDAR_NEO4J_HOST')
neo4j_port = int(os.environ.get('CEDAR_NEO4J_REST_PORT'))
neo4j_user = os.environ.get('CEDAR_NEO4J_USER_NAME')
neo4j_password = os.environ.get('CEDAR_NEO4J_USER_PASSWORD')

number_of_tries = 5
sleep_seconds = 1

print("---- Server info ----")
print("Neo4j server host   :" + str(neo4j_host))
print("Neo4j server port   :" + str(neo4j_port))
print("Neo4j server user   :" + str(neo4j_user))

print("Wait for Neo4j server to be available")

wait_for_neo4j()
