Docker Cheetsheet
=================

Running Containers
------------------

Run a container::

    $ docker run image-name

Run a container in interactive mode::

    $ docker run -it image-name [command]

List running containers::

    $ docker ps

List all containers::

    $ docker ps -a

Stop a running container::

	$ docker stop container-name-or-id

Delete a stopped container::

	$ docker rm container-name-or-id

Troubleshooting
---------------

Run a command inside a running container::

	$ docker exec -it container-name command

Images
------

List images::

	$ docker images

Delete an image::

	$ docker rmi image:tag
	$ docker rmi image-id

Volumes
-------

Expose a host directory as a volume::

	$ docker run -v host-directory:container-directory image

Expose current directory as a volume::

	$ docker run -v $PWD:/container-path image

Networking
----------

Expose a port::

	$ docker run -p host-port:container-port image


Environment
-----------

Set environment variable when running a container::

	$ docker run -e VAR_NAME=value image
