import sys
import time
from flask import Flask, jsonify

app = Flask(__name__)

storage = []
readiness = False
response_delay = 0
stime = time.time()

def get_storage_size():
    global storage
    if len(storage):
        return len(storage) * sys.getsizeof(storage[0])
    else:
        return 0

@app.route('/')
def index():
    global storage
    global readiness
    global liveness
    global response_delay
    global stime

    return jsonify({
        "storage size": "{:.2f} MB".format(get_storage_size()/(2**20)),
        "readiness": readiness,
        "response delay": "{}s".format(response_delay),
        "time since start": "{:.2f}s".format(time.time() - stime)
    })

@app.route('/memleak')
def memleak():
    global storage

    with open('file.txt') as f:
        data = f.read()
        storage.append(data)

    return jsonify({
        "storage size": "{:.2f} MB".format(get_storage_size()/(2**20))
    })

@app.route('/timeleak')
def timeleak():
    global response_delay

    response_delay += 0.5

    return jsonify({
        "response": "probes delayed by 0.5s"
    })

@app.route('/fibonacci/<int:num>')
def fibonacci(num):
    def fib(n):
        return fib(n-1) + fib(n-2)

    return jsonify({
        "result": fib(num)
    })

@app.route('/ready')
def readiness_probe():
    global stime
    global readiness
    if time.time() - stime > 5:
        readiness = True
        return jsonify({"ready": "yaayy!!! :)"}), 200
    else:
        return jsonify({"ready": "naayy!!! :("}), 500

@app.route('/healthy')
def liveness_probe():
    global response_delay
    time.sleep(response_delay)
    return jsonify({"ready": "yaayy!!! :)"}), 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080, debug=True)