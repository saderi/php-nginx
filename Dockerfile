ARG PHP_VERSION=8.1
ARG NODE_VERSION=16
ARG DEBIAN_VERSION=bullseye

FROM --platform=${BUILDPLATFORM} node:${NODE_VERSION}-slim AS NodeJS
FROM --platform=${BUILDPLATFORM} php:${PHP_VERSION}-fpm-${DEBIAN_VERSION}

RUN APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 \
    && apt-get update && env ACCEPT_EULA=Y apt-get install --assume-yes --no-install-recommends \
        gnupg2 \
        iputils-ping \
        dnsutils \
        curl \
        git \
        vim \
        supervisor \
        nginx \
        unzip \
        jq \
        telnet \
    && rm -rf /var/lib/apt/lists/*

# Install defualt extension
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions && sync && \
    install-php-extensions \
        bcmath \
        pdo \
        pdo_mysql \
        mysqli \
        gd \
        exif \
        xsl \
        soap \
        zip \
        opcache \
        intl \
        pcntl \
        pdo_pgsql \
        iconv \
        sockets \
        redis \
        mcrypt \
        sqlsrv \
        pdo_sqlsrv \
        memcached \
        imagick \
        xlswriter \
        @composer \
        # just install xdebuf (not enable it) 
        && IPE_DONT_ENABLE=1 install-php-extensions xdebug

# Add NodeJS & install yarn
COPY --from=NodeJS /usr/local/bin/node /usr/local/bin
COPY --from=NodeJS /usr/local/lib/node_modules /usr/local/lib/node_modules
RUN ln -s  /usr/local/bin/node /usr/local/bin/nodejs && \
    ln -s  /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm && \
    ln -s  /usr/local/lib/node_modules/npm/bin/npx-cli.js /usr/local/bin/npx && \
    ln -s  /usr/local/lib/node_modules/corepack/dist/corepack.js /usr/local/bin/corepack && \
    npm i -g yarn

RUN curl -L -o /usr/local/bin/php-security-checker https://github.com/fabpot/local-php-security-checker/releases/download/v2.0.3/local-php-security-checker_2.0.3_linux_amd64 \
    && chmod o+x /usr/local/bin/php-security-checker

COPY supervisor /etc/supervisor
COPY php/zzz-app.conf /usr/local/etc/php-fpm.d/zzz-app.conf
COPY php/www.conf /usr/local/etc/php-fpm.d/www.conf
COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/nginx-site.conf /etc/nginx/sites-available/nginx-site.conf
RUN ln -s /etc/nginx/sites-available/nginx-site.conf /etc/nginx/conf.d/nginx-site.conf

COPY wait-for-it.sh /usr/local/bin/wait-for-it
RUN chmod o+x /usr/local/bin/wait-for-it

# Change memory_limit for php-cli
RUN cp /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini \
    && sed -i 's,^memory_limit =.*$,memory_limit = -1,' /usr/local/etc/php/php.ini

EXPOSE 80 443

CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]
