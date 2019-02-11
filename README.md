# Dockerized 1000kit wildfly image

This repository contains `JBoss Wildfly` image.


### Installed versions:

 Wildfly 15.0.1.Final

### Availability

The `Dockerfile` is available in the `master` branch and is built in the Docker HUB as `1000kit/wildfly:latest`.

## Build Image

Take a Dockerfile and build with the default arguments:

~~~~
$ docker build -t 1000kit/wildfly .
~~~~

or simply use the `build.sh` script

##RUN

~~~~
$ docker run -it 1000kit/wildfly
~~~~

