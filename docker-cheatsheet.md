# Docker Cheetsheet

---
## Containers

**Run a container:** 

```docker run image-name```


**List running containers:**

```docker ps```

**List all containers:**

```docker ps -a```

**Stop a container**

```docker stop container-id-or-name```

---
## Images

**List Images**

```docker images```

**Pull an Image**

```docker pull image-name:optional-tag```

**Remove an image**

```docker rmi image-name:optional-tag```

---
# Environment

**Set environment variable when running a container:**

```
docker run -e VAR_NAME=value image
```

---
# Networking

**Expose a port:**

```docker run -p host-port:container-port image
```

---
## Volumes

**Expose a host directory as a volume:**

```docker run -v host-directory:container-directory image
```

**Expose current directory as a volume:**

```docker run -v $PWD:/container-path image
```

---
## Troubleshooting

**Run a command inside a running container:**

```docker exec -it container-name command
```

**Inspect a container**
```docker inspect containter-name```

