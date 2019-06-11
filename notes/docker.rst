Introduction to Docker
======================
.. epigraph::

	*"All problems in computer science can be solved by another level of indirection."*

	*-- David Wheeler*

Hello, world!
-------------

Let's run our first container. ::

	$ docker run hello-world
	Unable to find image 'hello-world:latest' locally
	latest: Pulling from library/hello-world
	1b930d010525: Pull complete
	Digest: sha256:0e11c388b664df8a27a901dce21eb89f11d8292f7fca1b3e3c4321bf7897bffe
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

Carefully look at the output of the above command. It did the following things:

* Checked if the image hello-world is present locally
* Pull the image from the default docker registry
* Started a container with that image
* Printed the output of the container to the terminal

If you trying the same command again, it will not pull the image again as it will find it locally.

..
	Image, Container and Registry
	-----------------------------

	::

		$ docker ps -a

		CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                      PORTS               NAMES
		c040192a6b5f        hello-world         "/hello"            8 minutes ago       Exited (0) 8 minutes ago                        priceless_newton


Building Docker Images
----------------------

We can create the docker images by writing a ``Dockerfile``. The Dockerfile contains the instructions to build the image. The following example, build a docker image to run the ``figlet`` program::

	$ cat Dockerfile
	# take ubuntu as the base image
	FROM ubuntu

	# run apt-get update and apt-get install commands as part of the build
	RUN apt-get update
	RUN apt-get -y install figlet

	# When running the container, use the following as the default command
	CMD ["figlet", "hello docker"]

	$ docker build -t figlet .
	...
	Successfully tagged figlet:latest

That created a new image `figlet`.

Let's try running it::

	$ docker run figlet
	 _          _ _             _            _
	| |__   ___| | | ___     __| | ___   ___| | _____ _ __
	| '_ \ / _ \ | |/ _ \   / _` |/ _ \ / __| |/ / _ \ '__|
	| | | |  __/ | | (_) | | (_| | (_) | (__|   <  __/ |
	|_| |_|\___|_|_|\___/   \__,_|\___/ \___|_|\_\___|_|


``CMD`` vs. ``ENTRYPOINT``
^^^^^^^^^^^^^^^^^^^^^^^^^^

The ``CMD`` directive is used to specify the default command to run and this is used when no arguments is specified after docker run image-name.

On the otherhand ``ENTRYPOINT`` specifies the the command always executed and the any arguments passed to ``docker run image-name`` are passed to the entrypoint script.

Let's build a new image with entrypoint.
::

	$ cat Dockerfile
	FROM ubuntu
	RUN apt-get update
	RUN apt-get -y install figlet
	ENTRYPOINT ["figlet"]

	$ docker build -t figlet:1.2
	...

	$ docker run figlet:1.2 docker
	     _            _
	  __| | ___   ___| | _____ _ __
	 / _` |/ _ \ / __| |/ / _ \ '__|
	| (_| | (_) | (__|   <  __/ |
	 \__,_|\___/ \___|_|\_\___|_|

Compare it with how we ran it with the version 1.1 of the image.

**Problem:** Write a ``Dockerfile`` to create a docker image ``cowsay``. The image should have the unix program ``cowsay`` installed and run ``cowsay`` with whatever is passed as arguments to docker run.

::

	$ docker run cowsay docker is awesome
	 ___________________
	< docker is awesome >
	 -------------------
	        \   ^__^
	         \  (oo)\_______
	            (__)\       )\/\
	                ||----w |
	                ||     ||

Hint: `cowsay` will be installed in `/usr/games/` and you may have to give full path `/usr/games/cowsay` to run it.


Example: ``figsay``
^^^^^^^^^^^^^^^^^^^

Let's combine both ``figlet`` and ``cowsay`` as a single application.

::

	$ mkdir figsay
	# create figsay.sh file with the following contents
	$ cat figsay.sh
	#! /bin/bash
	figlet $* | /usr/games/cowsay -n

	$ chmod +x figsay.sh

Now we can create a `Dockerfile`::

	$ cat Dockerfile
	FROM ubuntu
	RUN apt-get update
	RUN apt-get -y install figlet cowsay
	ADD figsay.sh /
	ENTRYPOINT ["/figsay.sh"]

And the final step is to build the image.

	$ docker build -t figsay .
	...
	Successfully tagged figsay:latest

Ready to try?

::

	$ docker run figsay docker
	 __________________________________
	/      _            _              \
	|   __| | ___   ___| | _____ _ __  |
	|  / _` |/ _ \ / __| |/ / _ \ '__| |
	| | (_| | (_) | (__|   <  __/ |    |
	|  \__,_|\___/ \___|_|\_\___|_|    |
	\                                  /
	 ----------------------------------
	        \   ^__^
	         \  (oo)\_______
	            (__)\       )\/\
	                ||----w |
	                ||     ||

