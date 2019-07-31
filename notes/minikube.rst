.. raw:: latex

    \clearpage

Setting up local kubernetes instance using minikube
===================================================

Minikube is a good option if you want to setup a local kubernetes
cluster. Here are the instructions:

Run the following commands as root. You can get root shell by running: ::

    $ sudo bash

After you get root shell, run the following commands: ::

    $ apt update
    $ apt install docker.io docker-compose
    $ snap install kubectl --classic
    $ curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    $ chmod +x minikube && mv minikube /usr/local/bin/

Start minikube using: ::

    $ minikube start --vm-driver=none

You can now exit out of the root shell.
Now, you can check information about the cluster by running: ::

    $ kubectl cluster-info
    Kubernetes master is running at https://139.59.40.141:8443
    KubeDNS is running at https://139.59.40.141:8443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

    To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
