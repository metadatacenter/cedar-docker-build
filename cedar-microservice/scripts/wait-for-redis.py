#!/usr/bin/python
import os
import time
import redis


def check_redis_connection(title_message, error_message):
    print(title_message + '...')
    conn = redis.StrictRedis(host=redis_host, port=redis_port)
    try:
        conn.ping()
    except Exception as e:
        print error_message
        print e
        return False
    finally:
        pass
    return True


def connect_to_redis():
    return check_redis_connection("Connecting to Redis", "Connection not available yet")


def wait_for_redis():
    print "Wait for Redis ..."
    number_of_successes = 0
    number_of_failures = 0
    while number_of_successes < number_of_tries:
        if connect_to_redis():
            number_of_successes += 1
        else:
            number_of_failures += 1
            number_of_successes = 0
        time.sleep(sleep_seconds)
        print "\tFailures:{},\tSuccesses:{}".format(number_of_failures, number_of_successes)


print "Reading environment variables"
redis_host = os.environ.get('CEDAR_REDIS_PERSISTENT_HOST')
redis_port = int(os.environ.get('CEDAR_REDIS_PERSISTENT_PORT'))

number_of_tries = 5
sleep_seconds = 1

print "---- Server info ----"
print "Redis server host   :" + redis_host
print "Redis server port   :" + str(redis_port)

print "Wait for Redis server to be available"

wait_for_redis()
