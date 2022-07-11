# Docker / PHP / nginx
This is a Dockerfile for PHP  with nginx, composer, nodejs



#### Running
To simply run the container:
```
docker run -d -p 8080:80 --name php-nginx saderi/php-nginx:latest
```
Then you can hit http://localhost:8080 or http://host-ip:8080 in your browser

