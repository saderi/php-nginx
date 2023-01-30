# What is this ?
This is a Dockerfile for PHP with nginx, composer, NodeJS, yarn

The Dockerfile is designed to build different versions of PHP and NodeJS. You can build your desired version with using the `--build-arg` option during build.

You can also build an image for your platform (arm or x64) with the `--platform` option.

# How to build
For building you must have Docker [buildx](https://docs.docker.com/build/buildx/install/) plugin on your machine.

**Note[0]:** By default, Dockerfile is set for **PHP 8.1** and **NodeJS 16** on Debian 11 (Bullseye).

**Note[1]:** Before building make sure [Docker HUB](https://hub.docker.com) have your base image you want. for example you want PHP 8.0.21 on debian Bullseye, so you must check this [link](https://hub.docker.com/_/php?tab=tags&page=1&name=8.0.21-fpm-bullseye), if you find your image in the HUB, you can continue and build your image.

These are some example for understanding how you can build your image:

## Example [1]
* **PHP:** 7.4
* **NodeJS:** 12.20.1
* **Platform:** Apple M1 chip  
```
    docker build --build-arg PHP_VERSION=7.4 \
                 --build-arg NODE_VERSION=12.20.1 \
                 --platform linux/arm64/v8
                 -t saderi/php-nginx:7.4 .

```

## Example [2]
* **PHP:** 8.0.21
* **Debian:** Buster (10)
* **NodeJS:** 16.5
* **Platform:** amd64  
```
    docker build --build-arg PHP_VERSION=8.0.21 \
                 --build-arg NODE_VERSION-16.5 \
                 --build-arg DEBIAN_VERSION=buster \
                 -t saderi/php-nginx:8.0.21 .

```

## Example [3]
* **PHP:** 8.1
* **NodeJS:** 16
* **Platform:** multi platform (Your machine must support multi platform build)
```
    docker build --build-arg PHP_VERSION=8.0.21 \
                 --build-arg NODE_VERSION-16.5 \
                 --platform linux/arm64/v8,linux/amd64
                 -t saderi/php-nginx:8.1 .

```

# Quick Start
```
docker pull saderi/php-nginx:8.1-bullseye
```

### Running
To simply run the container:
```
docker run -d -p 8080:80 --name php-nginx saderi/php-nginx:8.1-bullseye
```
Then you can hit http://localhost:8080 or http://host-ip:8080 in your browser


### Runngin with bind mount a volume
To run the container with volume:

Defualt webroot => `WEBROOT=/var/www/html`
```
docker run -d -p 8080:80 --name php-nginx -v /your/content/path:/var/www/html saderi/php-nginx:8.1-bullseye
```
