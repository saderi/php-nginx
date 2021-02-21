
# Docker / PHP / nginx
This is a Dockerfile for PHP  with nginx, composer, nodejs

## Quick Start
To pull from hub.docker.com:
```
docker pull saderi/php-nginx:latest
```
#### Running
To simply run the container:
```
docker run -d -p 8000:80 --name php-nginx saderi/php-nginx:latest
```
Then you can hit http://localhost:8000 or http://host-ip:8000 in your browser


#### Runngin with bind mount a volume
To run the container with volume:

Defualt webroot => `WEBROOT=/var/www/html`
```
docker run -d -p 8000:80 --name php-nginx -v /your/content/path:/var/www/html saderi/php-nginx:latest
```

#### Access to running container bash
Change `php-nginx` if you changed it.
```
docker exec -it php-nginx bash
```

