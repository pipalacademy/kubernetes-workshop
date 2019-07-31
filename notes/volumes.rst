Volumes
=======

After a Pod is deleted, all the data in the Pod is lost. There will be cases where we want to persist data across pod restarts. Kubernetes supports this using Volumes.

Types of Volumes
================

Kubernetes suppports the many different types of volumes. The commonly used ones are:

* emptyDir - mount a new empty directory as volume
* hostPath - mounts an existing directory in the host as a volume

We can also create persistant volumes through Persitent Volume Claims as explainer later in this document.

Mounting a Volume
=================

The pod spec can specify how to mount a volume. The following example, mounts emptyDir as volume into nginx. ::

	apiVersion: apps/v1beta2
	kind: Deployment
	metadata:
	  name: nginx
	  labels:
	    app: nginx
	spec:
	  replicas: 1
	  selector:
	    matchLabels:
	      app: nginx
	  template:
	    metadata:
	      labels:
	        app: nginx
	    spec:
	      containers:
	        - name: nginx
	          image: "nginx:alpine"
	          ports:
	            - containerPort: 80
	          # the volumes that need to mounted in each container are 
	          # specified using volumeMounts
	          volumeMounts:
	            - name: html
	              mountPath: /usr/share/nginx/html

	      # all the volumes used in the Pod are listed here
	      volumes:
	        - name: html
	          emptyDir: {}


Volume Claims
=============

A Persistent Volume Claim (PVC) is a request to allocate storage. Through the cloud integration, Kubernetes will request the cloud to allocate that storage.

The following claims 1GB of storage to mount as volume for nginx::

	apiVersion: v1
	kind: PersistentVolumeClaim
	metadata:
	  name: nginx-volume
	spec:
	  accessModes:
	  - ReadWriteOnce
	  resources:
	    requests:
	      storage: 1Gi
	  storageClassName: gcePersistentDisk
	allowVolumeExpansion: true

The following example shows how to specify a PVC volume in a pod/deployment.

		  ...
	      # all the volumes used in the Pod are listed here
	      volumes:
	        - name: html
	          persistentVolumeClaim:
	          	claimName: nginx-volume

References
----------

* https://kubernetes.io/docs/concepts/storage/volumes/
* https://kubernetes.io/docs/concepts/storage/persistent-volumes/