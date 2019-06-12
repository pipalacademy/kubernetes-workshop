Using Private Docker Registry
=============================

To use a image from a private docker registry, you need to do two things:

* create a secret of type `docker-registry` with the credentials
* specify the secret name in the pod configuration

Creating the Secret
-------------------

Secret can be created using the following command:

::

    $ kubectl create secret docker-registry regcred \
        --docker-server=registry.k8s.pipal.in \
        --docker-username=pipal \
        --docker-password=secret-password
    secret/regcred created

We've created a secret of type `docker-registry` with name `regcred`.

Once the secret is created, you can verify if the secret is present using::

    $ kubectl get secrets
    NAME                  TYPE                                  DATA   AGE
    regcred               kubernetes.io/dockerconfigjson        1      4m42s

Create a Pod that uses an image from a private registry
-------------------------------------------------------

You need to specify `imagePullSecrets` in the pod spec to be able to use a docker image from a private registry.

The following example starts a pod using `graphviz-web` image from a private registry.
::

    apiVersion: v1
    kind: Pod
    metadata:
      name: graphviz-web
    spec:
      containers:
        - name: graphviz-web
          image: registry.k8s.pipal.in/graphviz-web
      imagePullSecrets:
        - name: regcred


Create a Deployment that uses an image from a private registry
--------------------------------------------------------------

The changes required for creating a deployment will be similar to the changes that we we did for a pod. We just need to specify `imagePullSecrets` in the template.

::

    apiVersion: apps/v1beta2
    kind: Deployment
    metadata:
      name: graphviz-web
      labels:
        app: graphviz-web
    spec:
      replicas: 2
      selector:
        matchLabels:
          app: graphviz-web
      template:
        metadata:
          labels:
            app: graphviz-web
        spec:
          containers:
            - name: graphviz-web
              image: registry.k8s.pipal.in/graphviz-web
              ports:
                - containerPort: 8080
              env:
                - name: GRAPHVIZ_API_ENDPOINT
                  value: http://graphviz-api.alpha.k8s.pipal.in/dot
          imagePullSecrets:
            - name: regcred
