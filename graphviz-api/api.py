import base64
import subprocess
import time
from firefly import Firefly

app = Firefly(allowed_origins='*')

@app.function()
def dot(input):
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
    print("generated graphviz image in {:.2f}s".format(t1-t0))
    return {"data": base64.b64encode(out).decode('ascii')}

if __name__ == "__main__":
    app.run(port=8000)
