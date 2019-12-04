
## introduction

deploy lnmn(Linux+Nginx+mysql+nodejs) using docker

## about architecture

![architecture][1]

The whole app is divided into three Containers:

1. nginx is running in `nginx` Container, which handles requests and makes responses.
2. node  is put in `nodejs` Container, it retrieves nodejs scripts from host, interprets, executes then responses to Nginx. If necessary, it will connect to `MySQL` as well.
3. MySQL lies in `MySQL` Container,

Our app scripts are located on host, you can edit files directly without rebuilding/restarting whole images/containers.

## build your images

At first, you should have had [Docker](https://docs.docker.com) and [Docker Compose](https://docs.docker.com/compose) installed.

    $ docker-compose build

## create,start and run your containers

Without building images one by one, you can make use of $(docker-compose) and simply use:

    $ docker-compose up --detach

For more operations to containers, please refer to:

    $ docker-compose --help

Check out your https://\<docker-host\> and have fun

i prefer to use : docker-compose up --build --detach

## contributors

ymc-github yemiancheng@gmail.com

## license

MIT

  [1]: architecture.png
