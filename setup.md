# Setting up Kubernetes

- Install kubectl
- Setup access to the common kubernetes cluster used in the workshop
- Install your own minikube cluster

## Installing `kubectl`

`kubectl` is the command-line tool for Kubernetes. It can be used to deploy and manage applications on Kubernetes. Using
this we can even inspect cluster resources, create, delete and update components.

### Linux Users

```bash
$ curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.13.2/bin/darwin/amd64/kubectl
...
$ chmod +x ./kubectl
$ sudo mv ./kubectl /usr/local/bin/kubectl
$ kubectl version
Client Version: version.Info{Major:"1", Minor:"13", GitVersion:"v1.13.2", GitCommit:"cff46ab41ff0bb44d8584413b598ad8360ec1def", GitTreeState:"clean", BuildDate:"2019-01-10T23:35:51Z", GoVersion:"go1.11.4", Compiler:"gc", Platform:"linux/amd64"}
Server Version: version.Info{Major:"1", Minor:"13", GitVersion:"v1.13.1", GitCommit:"eec55b9ba98609a46fee712359c7b5b365bdd920", GitTreeState:"clean", BuildDate:"2018-12-13T10:31:33Z", GoVersion:"go1.11.2", Compiler:"gc", Platform:"linux/amd64"}

```

### Mac Users

```bash
$ curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.13.2/bin/linux/amd64/kubectl
...
$ chmod +x ./kubectl
$ sudo mv ./kubectl /usr/local/bin/kubectl
$ kubectl version
Client Version: version.Info{Major:"1", Minor:"13", GitVersion:"v1.13.2", GitCommit:"cff46ab41ff0bb44d8584413b598ad8360ec1def", GitTreeState:"clean", BuildDate:"2019-01-10T23:35:51Z", GoVersion:"go1.11.4", Compiler:"gc", Platform:"linux/amd64"}
Server Version: version.Info{Major:"1", Minor:"13", GitVersion:"v1.13.1", GitCommit:"eec55b9ba98609a46fee712359c7b5b365bdd920", GitTreeState:"clean", BuildDate:"2018-12-13T10:31:33Z", GoVersion:"go1.11.2", Compiler:"gc", Platform:"linux/amd64"}

```

## Accessing the shared kubernetes cluster

A kubernetes cluster has been setup to be used by all the participants of the workshop.

## Setting up `minikube`

Minikube is a tool that makes it easy to run Kubernetes locally. Minikube runs a single-node Kubernetes cluster on your system for users. It makes things simpler for people looking to try out Kubernetes or develop with it day-to-day.

### Linux Users

```bash
$ curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
...
$ chmod +x ./minikube
$ sudo mv ./minikube /usr/local/bin/minikube
$ minikube version
minikube version: v0.33.1

```

### Mac Users

```bash
$ curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-darwin-amd64
...
$ chmod +x ./minikube
$ sudo mv ./minikube /usr/local/bin/minikube
$ minikube version
minikube version: v0.33.1

```
