Running Multi-container Applications
====================================
.. epigraph::

	*"Alone we can do so little; together we can do so much."*

	*-- Helen Keller*

Very often, an application requires running more than one container. You may have a front-end and a backend, or webapp, database, redis cache and an offline worker. It is very tedious to manage them manually.

Also, we may need to run all of them for local development and for running tests as part of CI/CD pipeline. It is very important to have a repeatable way to handle that. In this chapter, we'll explore docker-compose, a tool created to solve this very problem.

Docker Compose
--------------

Docker Compose is a tool for defining and running Docker applications with multiple applications. With Docker Compose, you define the configuration of your application's service in a simple and easy to understand YAML format. After that, you can just run a single command to create and start all the services from our configuration.

Docker Compose introduces the concept of **Services**. Services are constituent units of your application. For example, if you have a database-backed web application you may have database, backend and frontend services.

With Docker Compose you can:

- Start, stop, and rebuild services
- View the status of running services
- Stream the log output of running services
- Run a one-off command on a service

The above actions essentially gives you an all round lifecycle management of your application.

Example: nginx
^^^^^^^^^^^^^^

Let's create a simple html file to serve it using nginx.

::

	$ mkdir html
	$ echo "<h1>Hello, docker!</h1>" > html/index.html

We can run ngnix with docker using::

	$ docker run -p 80:80 -v $PWD/html:/usr/share/nginx/html nginx

That would serve the html files from ``html/`` directory.

Lets see how to do the same using docker-compose.

Create a file with name ``docker-compose.yml`` with the following contents.

::

	version: '2'
	services:
	  web:
	    image: nginx
	    ports:
	      - 80:80
	    volumes:
	      - ./html:/usr/share/nginx/html

Start all the services specified in ``docker-compose`` using::

	$ docker-compose up
	...

You can press Ctrl+C to stop all the services.

**Problem:** Run the ``graphviz-web`` and ``graphviz-api`` services using docker-compose.


Example: graphviz-web
^^^^^^^^^^^^^^^^^^^^^

In the last chapter, we've seen how to run the graphviz-web and graphviz-api services manually. Let's see how to streamline that using docker-compose.

::

	$ cd graphviz-web
	$ cat docker-compose.yml
	version: '3'
	services:
	  web:
	    image: pipalacademy/graphviz-web
	    ports:
	      - "8080:8080"
	    environment:
	      - GRAPHVIZ_API_ENDPOINT=http://alpha.docker.pipal.in:8000/dot
	  api:
	    image: pipalacademy/graphviz-api
	    ports:
	      - "8000:8000"

Now you can start both the services using::

	$ docker-compose up

This runs both graphviz-web and graphviz-api services using the docker images available in the docker registry. Lot of times, we may want to build the docker image from the source instead of using an already existing image. Docker-compose supports that by specifying ``build`` parameter. The following example, uses the image build from source for graphviz-web.

::
	$ cat docker-compose.yml
	version: '3'
	services:
	  web:
	    # Asking docker-compose to build an image from the current directory
	    build: .
	    ports:
	      - "8080:8080"
	    environment:
	      - GRAPHVIZ_API_ENDPOINT=http://alpha.docker.pipal.in:8000/dot
	  api:
	    image: pipalacademy/graphviz-api
	    ports:
	      - "8000:8000"
