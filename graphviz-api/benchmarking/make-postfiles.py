"""Generates post payload for each dot file in the directory.

Useful for benchmarking using ab.
"""
import json
import os
import glob

for path in glob.glob("*.dot"):
    path2 = path.replace(".dot", ".txt")
    print("{} -> {}".format(path, path2))
    d = {"input": open(path).read()}
    with open(path2, "w") as f:
        f.write(json.dumps(d))
