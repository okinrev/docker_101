import os
from flask import Flask
import redis

app = Flask(__name__)

@app.route("/")
def root():
    return "Hello World"

@app.route("/redis")
def check_redis():
    try:
        global redis
        connection = redis.Redis(
            host= os.environ.get("REDIS_HOST", 'redis'),
            port= os.environ.get("REDIS_PORT", '6379'))
        connection.ping()
        return "KO", 500
    except:
        return "OK"
