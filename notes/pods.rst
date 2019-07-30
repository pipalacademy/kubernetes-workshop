Pods
====

When working with containers we have seen how to run individual containers, but in many real-world use cases, you may need to run multiple containers together to achieve an objective. 

In Kubernetes, Pod is the smallest schedulable unit, made of one or more containers and the associated the associated volumes. This means all the containers in the Pod always run on the same node.

It is tempting to think that you can put database server and a webapp in a Pod, but that is not how it is done. Multiple containers are put in a Pod only when they have run togetger. If we run the database server and the webapp in a different nodes, the application runs equally well. 

Think of cases like you have an that is writing logs to a file and you want to send those logs to a centralized server. You run your application in one container and put a log collector in another container in the same Pod. These 2 containers now form a schedulable unit. You can as many of these as you want.

Creating a Pod
--------------

Simplest way to create a pod is using the `kubectl run` command::

    $ kubectl run nginx --image=nginx:alpine
    deployment.apps "nginx" created

    $ kubectl get pods
    NAME                     READY     STATUS    RESTARTS   AGE
    nginx-64d9675947-ss845   1/1       Running   0          15s 

The `kubectl run`, creates a Deployment and that creates a Pod through a ReplicaSet, which will be covered later. You can try deleting the Pod and a new one takes its place as the ReplicaSet make sure there is always a Pod running. ::

    $ kubectl delete pod nginx-64d9675947-ss845;
    pod "nginx-64d9675947-ss845" deleted

    $ kubectl get pods
    NAME                     READY     STATUS              RESTARTS   AGE
    nginx-64d9675947-9r8wj   0/1       ContainerCreating   0          2s
    nginx-64d9675947-ss845   1/1       Terminating         0          3m
 
For now, we will focus only on Pods. Let's continue with deleting the deployment that we've created and move on to creating a Pod using manifest. ::

    $ kubectl delete deployment nginx
    deployment.extensions "nginx" deleted

Creating a Pod using Manifest
-----------------------------

The standard way to specify the API objects, including Pods is writing a manitest file in YAML or JSON, but YAML is most popular because it is easy to read.

Lets start with wrtiting a manifest for a Pod in a file ``pod.yaml``::

    apiVersion: v1
    kind: Pod
    metadata:
      name: nginx
    spec:
      containers:
        - name: nginx
          image: nginx:alpine
          ports:
            - containerPort: 80
              name: http
              protocol: TCP

Please note that in the Kubernetes ecosystem, people use `.yaml` as extension and not `.yml`. 

All the fields in the manifest is self explanatory. So many details in the manifest may seem overwhelming. Don't worry! We usually never write these files from scratch. Typically we take an existing manifest from make the required changes.

The mantra to apply any kubernetes manifest file is `kubectl apply`.  The following command applies the pod manifest::

    $ kubectl apply -f pod.yaml

This will create a new Pod. You can apply the manifest as many times as you want, but it will only create a single Pod. ::

    $ kubectl get pods
    NAME      READY     STATUS    RESTARTS   AGE
    nginx     1/1       Running   0          3s

You can use `-o wide` option to see where the Po is running::

    $ kubectl get pods -o wide
    NAME      READY     STATUS    RESTARTS   AGE       IP           NODE
    nginx     1/1       Running   0          4m        10.56.3.11   gke-k8s-workshop-k8s-node-pool-3fbab998-hg9j

You can look at more detailed information about the Pod usng `kubectl describe`::

    $ kubectl describe pod nginx
    Name:               nginx
    Namespace:          default 
    ...
    Node:               ...
    Labels:             ...
    Annotations:        ...
    ...
    Status:             Running
    IP:                 10.56.3.11

    Containers:
      nginx:
        Image:          nginx:alpine      
        ...

    Events:
      Type    Reason     Age   From                                                   Message
      ----    ------     ----  ----                                                   -------
      Normal  Scheduled  28s   default-scheduler                                      Successfully assigned default/nginx to gke-k8s-workshop-k8s-node-pool-3fbab998-hg9j
      Normal  Pulled     28s   kubelet, gke-k8s-workshop-k8s-node-pool-3fbab998-hg9j  Container image "nginx:alpine" already present on machine
      Normal  Created    28s   kubelet, gke-k8s-workshop-k8s-node-pool-3fbab998-hg9j  Created container
      Normal  Started    28s   kubelet, gke-k8s-workshop-k8s-node-pool-3fbab998-hg9j  Started container

It shows all the metadata of the Pod, including the recent events that have happened to this Pod. That also explains how to Kubernetes starts a Pod.

The following things happen when we apply the Pod manifest:

* The API server creates a Pod API Object and saves it to `etcd`
* The `scheduler` sees that and schedules it to one of the nodes
* The `kubelet` running on that node notices that a new Pod is scheduled to this node and starts creating all the containers specified in the Pod

Accessing the Pod
-----------------

The Pod is running the Kubernetes cluster, but we have no way to access it yet. One simple way to access it is using port-forward::

    $ kubectl port-forward nginx 8080:80
    Forwarding from 127.0.0.1:8080 -> 80
    Forwarding from [::1]:8080 -> 80

You can now access it by running the following on your machine::

    $ curl http://localhost:8080/
    ...
    <h1>Welcome to nginx!</h1>    
    ...

If you want to use from other machines connected to it, you need to specify 0.0.0.0 as the interface.

    $ kubectl port-forward nginx --address 0.0.0.0 8080:80    
    Forwarding from 0.0.0.0:8080 -> 80    

Now, you can access the Pod anywhere from `http://your-machine-name-or-ip:8080/`.

While this is a quick way to expose a Pod, the most common way to expose a Pod or a set of Pods is through a Service. We'll look into that shortly.

Troubleshooting
---------------

We can look the logs of the container using `kubectl logs` command::

    $ kubectl  logs nginx
    127.0.0.1 - - [30/Jul/2019:03:00:27 +0000] "GET / HTTP/1.1" 200 612 "-" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.109 Safari/537.36" "-"

We can follow the logs using `-f` option::

    $ kubectl logs -f nginx
    127.0.0.1 - - [30/Jul/2019:03:00:27 +0000] "GET / HTTP/1.1" 200 612 "-" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.109 Safari/537.36" "-"

It is also possible to run commands inside the container using `kubectl exec`::

    $ kubectl exec -it nginx /bin/sh
    / # ps
    PID   USER     TIME  COMMAND
        1 root      0:00 nginx: master process nginx -g daemon off;
        6 nginx     0:00 nginx: worker process
       12 root      0:00 /bin/sh
       17 root      0:00 ps


It is also possible copy files to and from the containers. For example, the following command copied a file a.txt from local machine to the container in the Pod nginx. 

    $ kubectl a.txt nginx:/usr/share/nginx/a.txt

**Problem:** Make the nginx serve "Hello Kubernetes!" instead of the default index page. 
