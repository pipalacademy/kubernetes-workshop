# Common `kubectl` commands

The `kubectl` command is used to interact with any kubectl cluster from command-line.

The shared kubernetes cluster already has some applications running. You should be able to explore it using the `kubectl` command.

## List Nodes

```
$ kubectl get nodes
...
```

## List Pods

```
$ kubectl get pods
```

## List Services

```
$ kubectl get services
```

## List Deployments

```
$ kubectl get deployments
```

## Practice Problems

**Problem 1:** Port-forward the http-server pod that is running on port 8000 to your local machine and interact with it.

	kubectl port-forward http-server 8000 --namespace default

And visit http://localhost:8000/

To forward the port on 0.0.0.0, add addtional argument `--address 0.0.0.0`.

	kubectl port-forward http-server 8000 \
		--namespace default \
		--address 0.0.0.0

**Problem 2:** Install http-server in your own namespace and port-forward it to your local machine.
