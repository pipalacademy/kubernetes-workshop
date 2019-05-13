"""Fabric script to generate the kubeconfig files and copy them to all nodes.
"""
from __future__ import print_function
import os
import sys
from fabric.api import task, run, env, cd, sudo, put
import json
import os

env.hosts = [line.strip() for line in open("hosts.txt") if line.strip()]
env.user = 'pipal'
env.password = os.getenv("PASSWORD")

TOKENS_FILE = "terraform/_output/kubeconfig-tokens"

@task
def hello():
    run("echo hello world!")

@task
def setup():
    sudo("snap install kubectl --classic")
    ns = env.host.split(".")[0]
    process_namespace(ns)
    run("mkdir -p .kube")
    put("terraform/kube/{}/ca.crt".format(ns), ".kube/ca.crt")
    put("terraform/kube/{}/config".format(ns), ".kube/config")

TEMPLATE = """
apiVersion: v1
clusters:
- cluster:
    certificate-authority: /home/pipal/.kube/ca.crt
    server: https://ada3dbf1-047d-4cae-91d2-4b15cabfad83.k8s.ondigitalocean.com
  name: k8s
contexts:
- context:
    cluster: k8s
    user: {ns}
    namespace: {ns}
  name: {ns}
current-context: {ns}
kind: Config
preferences: {{}}
users:
- name: {ns}
  user:
    token: {token}
"""

def parse_tokens():
    data = json.load(open(TOKENS_FILE))
    return {d['namespace']: dict(ns=d['namespace'], token=d['token'], crt=d['ca']['crt']) for d in data}

TOKENS = parse_tokens()

def writefile(ns, filename, contents):
    root = "kube/" + ns
    if not os.path.exists(root):
        os.makedirs(root)
    path = root + "/" + filename
    print("writing", path, "...")
    with open(path, "w") as f:
        f.write(contents)

def process_namespace(ns):
    crt = TOKENS[ns]['crt']
    token = TOKENS[ns]['token']
    writefile(ns, "ca.crt", crt)

    config = TEMPLATE.format(ns=ns, token=token)
    writefile(ns, "config", config)
