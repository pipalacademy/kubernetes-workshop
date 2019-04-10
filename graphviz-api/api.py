import base64
import subprocess
import time
from firefly import Firefly

from prometheus_client import start_http_server, Counter, Summary

hits = Counter('hits', 'Number of total hits to the application')
request_time = Summary('request_time', 'Time taken to process a request')

app = Firefly(allowed_origins='*')

@app.function()
def dot(input):
    hits.inc()
    t0 = time.time()
    p = subprocess.Popen(
        args=["dot", "-Tpng"],
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE)
    try:
        out, err = p.communicate(input.encode('ascii'))
    except:
        raise
    if p.returncode != 0:
        raise ValueError(err.decode("ascii"))
    t1 = time.time()

    request_time.observe(t1-t0)

    print("generated graphviz image in {:.2f}s".format(t1-t0))
    return {"data": base64.b64encode(out).decode('ascii')}

if __name__ == "__main__":
    start_http_server(8001)
    app.run(port=8000)
