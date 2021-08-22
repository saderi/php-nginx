FROM php:7.4-fpm-buster

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -  \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    # Package install
    && APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 \
    && apt-get update && env ACCEPT_EULA=Y apt-get install -y --no-install-recommends \
        ca-certificates \
        iputils-ping \
        curl \
        wget \
        bash \
        supervisor \
        nginx \
        nodejs \
        # PHP extension dependency
        zlib1g-dev \
        libpng-dev \
        libjpeg-dev \
        imagemagick \
        libfreetype6-dev \
        libxslt-dev \
        libzip-dev \
        # PHP Mcrypt extension dependency
        libmcrypt-dev \
        # PHP Imagemagick extension dependency
        libmagickwand-dev \
        # Deploy tools
        yarn \
    && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-configure gd \
        --with-jpeg \
        --with-freetype \
        --with-jpeg \
    # Install defualt extension
    && docker-php-ext-install \
        bcmath \
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
    && pecl install imagick \
    && pecl install mcrypt \
    && pecl install redis \
    && docker-php-ext-enable \
        imagick \
        mcrypt \
        redis \
    # Delete extracted php source
    && docker-php-source delete

# Install php composer
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

COPY supervisor /etc/supervisor
COPY php/zzz-app.conf /usr/local/etc/php-fpm.d/zzz-app.conf
COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/nginx-site.conf /etc/nginx/sites-available/nginx-site.conf
RUN ln -s /etc/nginx/sites-available/nginx-site.conf /etc/nginx/conf.d/nginx-site.conf

COPY nginx_default.php /var/www/html/public/nginx_default.php

EXPOSE 80

CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]
