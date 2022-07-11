FROM node:16-slim AS NodeJS
FROM php:8.1-fpm-bullseye

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions && sync && \
    install-php-extensions \
        bcmath \
        gd \
        exif \
        xsl \
        soap \
        zip \
        intl \
        pdo_mysql \
        mysqli \
        mbstring \
        redis \
        mcrypt \
        imagick \
        pcntl \
        @composer

RUN APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 \
    && apt-get update && env ACCEPT_EULA=Y apt-get install -y --no-install-recommends \
        git \
        bash \
        supervisor \
        nginx \
    && rm -rf /var/lib/apt/lists/*

# Add NodeJS
COPY --from=NodeJS /usr/local/bin/node /usr/local/bin
COPY --from=NodeJS /usr/local/lib/node_modules /usr/local/lib/node_modules
RUN ln -s  /usr/local/bin/node /usr/local/bin/nodejs
RUN ln -s  /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm
RUN ln -s  /usr/local/lib/node_modules/npm/bin/npx-cli.js /usr/local/bin/npx
RUN ln -s  /usr/local/lib/node_modules/corepack/dist/corepack.js /usr/local/bin/corepack
RUN npm i -g yarn

# Add wait-for-it script https://github.com/vishnubob/wait-for-it
ADD https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh /usr/local/bin/wait-for-it
RUN chmod +x /usr/local/bin/wait-for-it


COPY zzz-app.conf /usr/local/etc/php-fpm.d/zzz-app.conf
COPY nginx.conf /etc/nginx/nginx.conf
COPY supervisor /etc/supervisor
RUN rm -rf /etc/nginx/conf.d/* /etc/nginx/sites-enabled/*

COPY docker-entrypoint /usr/local/bin/
RUN chmod o+x /usr/local/bin/docker-entrypoint

RUN mkdir /var/www/html/public
COPY index.php /var/www/html/public

EXPOSE 80
CMD ["docker-entrypoint"]
