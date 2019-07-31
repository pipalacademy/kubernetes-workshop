.. raw:: latex

    \clearpage

Common `kubectl` commands
=========================

The ``kubectl`` command-line tool is the official client of Kubernetes. It is used to interact with the Kubernetes API server and create API objects.

Check Cluster Status
--------------------

The ``kubectl version`` prints the version of client and server.

::

	$ kubectl version
	Client Version: version.Info{Major:"1", Minor:"14", GitVersion:"v1.14.2", GitCommit:"66049e3b21efe110454d67df4fa62b08ea79a19b", GitTreeState:"clean", BuildDate:"2019-05-16T16:23:09Z", GoVersion:"go1.12.5", Compiler:"gc", Platform:"linux/amd64"}
	Server Version: version.Info{Major:"1", Minor:"14", GitVersion:"v1.14.1", GitCommit:"b7394102d6ef778017f2ca4046abbaa23b88c290", GitTreeState:"clean", BuildDate:"2019-04-08T17:02:58Z", GoVersion:"go1.12.1", Compiler:"gc", Platform:"linux/amd64"}

Get status of the kubernetes cluster::

	$ kubectl  get componentstatus
	NAME                 STATUS    MESSAGE             ERROR
	scheduler            Healthy   ok
	controller-manager   Healthy   ok
	etcd-0               Healthy   {"health":"true"}

Dump detailed cluster info for investigation::

	$ kubectl cluster-info dump
	...

Viewing Kubernetes API Objects
------------------------------

To get information about kubenetes objects ::

	$ kubectl get <resource-name>
	$ kubectl get <resource-name> <object-name>
	$ kubectl get <resource-name>/<object-name>

For example::

	# List all nodes
	$ kubectl get nodes

	# List all pods
	$ kubectl get pods

	# List all services
	$ kubectl get services
	$ kubectl get svc

	# List all replicasets
	$ kubectl get replicasets
	$ kubectl get rc

	# List all deployments
	$ kubectl get deployments

To get detailed information about kubenetes objects ::

	$ kubectl describe <resource-name>
	$ kubectl describe <resource-name> <object-name>
	$ kubectl describe <resource-name>/<object-name>

For example::

	# describe all nodes
	$ kubectl describe node
	$ kubectl describe nodes

	# describe a node
	$ kubectl describe node node-name

	# describe a pod
	$ kubectl describe pod pod-name

	# describe a service
	$ kubectl describe service name
	$ kubectl describe svc name

	# describe a replicaset
	$ kubectl describe replicaset name
	$ kubectl describe rs name

	# describe a deployment
	$ kubectl describe deployment name

Creating, Updating and Deleting Kubernetes Objects
--------------------------------------------------

Kubernetes objects are specified in YAML files. The file may contain one or more kubernetes objects.

To create or update objects specified in an YAML file::

	$ kubectl apply -f filename.yaml

To delete all objects specified in an YAML file::

	$ kubectl delete -f filename.yaml

To delete an object by name::

	$ kubectl delete <resource-name> <object-name>

For example::

	# delete pod nginx-123
	$ kubectl delete pod nginx-123

	# delete service nginx
	$ kubectl delete service nginx

Troubleshooting
---------------

Look at logs of an existing pod::

	$ kubectl logs pod-name

Look at logs of an multiple pods at once using labels::

	# show logs of all pods with label app=nginx
	$ kubectl logs -l app=nginx

Get a shell into a running container::

	$ kubectl exec -it pod-name bash
