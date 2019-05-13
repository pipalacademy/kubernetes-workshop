# Introduction to Docker

```
 ____             _
|  _ \  ___   ___| | _____ _ __
| | | |/ _ \ / __| |/ / _ \ '__|
| |_| | (_) | (__|   <  __/ |
|____/ \___/ \___|_|\_\___|_|
```

- What is docker?
- What is the difference between docker and VM?
- Docker Terminology
	- image
	- container
	- registry
  -

## What is Docker

Docker is a popular open-source container engine.

Container is a way to package a software application with all its dependencies so that it can run on any environment. This includes everything that is required to run the application: the code, system tools, settings etc.

Unlike VMs, containters are light weight. Since they share the host machine's OS kernel, it does not require running an OS for each application.

## Docker Terminology

**Image:** Docker container image is a package of the application that is required to run a docker container.

**Container:** Docker container is an image in execution. There could be
multiple containers running for the same image. Each container will have
a unique id and a name.

**Registry:** Docker Registry is a repository of docker images. By
default, docker provides a public docker registry at
https://hub.docker.com/

**Dockerfile:** Dockerfile is a file that is used to specify how to
build a docker image. It contains the steps to build a docker image.

## Hello, world!

Docker is already installed on your dev nodes. You can verify if it is
working by running the command `docker version`.

```
$ docker version
Client:
 Version:           18.09.2
 API version:       1.39
 Go version:        go1.10.4
 Git commit:        6247962
 Built:             Tue Feb 26 23:52:23 2019
 OS/Arch:           linux/amd64
 Experimental:      false

Server:
 Engine:
  Version:          18.09.2
  API version:      1.39 (minimum version 1.12)
  Go version:       go1.10.4
  Git commit:       6247962
  Built:            Wed Feb 13 00:24:14 2019
  OS/Arch:          linux/amd64
  Experimental:     false
```

That shows the version of both the docker client and the docker server. 

Lets start running hello-world in docker.

```
$ docker run hello-world
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
1b930d010525: Pull complete
Digest: sha256:5f179596a7335398b805f036f7e8561b6f0e32cd30a32f5e19d17a3cda6cc33d
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/
```

Awesome! You've run your first docker container!! 

The output of that command explains what all happens to run that simple container. If haven't read it, please take a minute to read it carefully.

**Problem:** Run `bash` in `ubuntu` container and install figlet.

## Docker cheatsheet

See [Docker cheatsheet](docker-cheatsheet.md).

