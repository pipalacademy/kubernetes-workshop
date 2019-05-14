# Introduction to Docker Compose

- What is Docker Compose?
- Approach
- Common Use Cases
- Examples
- Exercise

## What is Docker Compose

Docker Compose is a tool for defining and running Docker applications with multiple applications. With Docker Compose, you define the configuration of your application's service in a simple and easy to understand YAML format. After that, you can just run a single command to create and start all the services from our configuration.

Docker Compose introduces the concept of **Services**. Services are constituent units of your application. For example, if you are running a `database` backed application which has a `backend` and `frontend`, `database`, `backend` and `frontend` are services.

With Docker Compose you can:
  - Start, stop, and rebuild services
  - View the status of running services
  - Stream the log output of running services
  - Run a one-off command on a service

The above actions essentially gives you an all round lifecycle management of your application.

## Installation

```bash
$ sudo apt-get update
$ sudo apt-get install -y docker-compose
```

## Common Use Cases

In software development, we should be able to test and interact with our applications in a disposable and isolated environment. Docker Compose helps us in achieving that isolation.

It also helps us in starting an environment to perform end-to-end tests. This is a very important part of the Continuous Integration/Continuous Deployment process. We should also be able to destroy the environment as soon as the tests are done.

## Approach

Using Docker Compose is basically a three-step process:
  1. Define your app’s environment with a Dockerfile so it can be reproduced anywhere.
  2. Define the services that make up your app in `docker-compose.yml` so they can be run together in an isolated environment.
  3. Run `docker-compose up` and Compose starts and runs your entire app.

We will see in the next section how to run a simple `nginx` deployment.

## Example: nginx

Lets create a simple html file to serve it using nginx.

```bash
$ mkdir html
$ echo "<h1>Hello, docker</h1>" > html/index.html
```

We can run ngnix with docker using:

```bash
$ docker run -p 8000:80 -v $PWD/html:/usr/share/nginx/html nginx
```

That would serve the html from `html/` directory.

Lets see how to do the same using Docker Compose.

Create a file with name `docker-compose.yml` with the following contents:

```
version: '3'
services:
  web:
    image: nginx
    ports:
      - 8000:80
    volumes:
      - ./html:/usr/share/nginx/html
```

Start all the services specified in docker-compose using:

```bash
$ docker-compose up
```

## Exercise

Let's deploy our own image uploader application - **klickr**. The application will allow users to upload photos and display them as an album. The application also creates thumbnails of three sizes small, medium and large for every photo uploaded by the user and this process of thumbnail creation is run in a task worker.

**klickr** is made up of two services - a web application and a background task worker. Both of these services require a `postgres` database and a `redis` cache.

The code for **klickr** is available here: `https://github.com/pipalacademy/klickr`. Please clone the repository to your machine.

```bash
$ git clone https://github.com/pipalacademy/klickr
```

The `Dockerfile` for the application has already been provided in the repository. The task is to write the `docker-compose.yml` for `klickr`.

**klickr** will have the following services:

### database

The `postgres` database which keeps track of the photos uploaded.

The username should be `pipal`, the password should be `vmware-docker` and the database should be `klickr`. The postgres database data should be mounted as a volume from your local directory.

Hint: This is how you would run a postgres container using docker:
```bash
$ docker run -p 5432:5432 -v `pwd`/data/postgresql:/var/lib/postgresql -e POSTGRES_DB=klickr -e POSTGRES_USER=pipal -e POSTGRES_PASSWORD=vmware-docker postgres
```

### redis

The `redis` service the `redis` software which acts as a task queue for our rask worker.

There are no environment variables required for deploying redis as a service, in this example.

Hint: You can use `redis:alpine` as the image.

### web

The web application which serves the UI and handles the user uploads.

The web application runs at the port `5000` and expects the environment variables `DATABASE_URL` and `REDIS_URL`. This also requires a volume to be mounted at `/app/klickr/static/photos` so that our photos persist.

### worker

The task worker which creates the thumbnails for each photo uploaded by the user.

For task worker, you have to use the same image as the web application. But, the command for the image here would be different. You should use `./worker.sh` in the command field.

## References

- [Docker Compose - Getting Started](https://docs.docker.com/compose/gettingstarted/)
- [Docker Compose - Samples](https://docs.docker.com/compose/samples-for-compose/)
