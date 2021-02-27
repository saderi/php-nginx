FROM php:7.4-fpm-buster

RUN mkdir -p /usr/share/man/man1mkdir -p /usr/share/man/man1 \
    && curl -sL https://deb.nodesource.com/setup_12.x | bash -  \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    # Package install
    && APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 \
    && apt-get update && env ACCEPT_EULA=Y apt-get install -y --no-install-recommends \
        ca-certificates \
        iputils-ping \
        curl \
        wget \
        vim \
        bash \
        supervisor \
        nginx \
        nodejs \
        jq \
        # Cerbot for nginx
        certbot \
        python-certbot-nginx \
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
        openssh-client \
        # PHP MongoDB extension dependency
        libcurl4-openssl-dev pkg-config libssl-dev \
    && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-configure gd \
        --with-jpeg \
        --with-freetype \
        --with-jpeg \
    # Install defualt extension
    && docker-php-ext-install \
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
        iconv \
    && pecl install imagick-3.4.3 \
    && pecl install mcrypt-1.0.3 \
    && pecl install redis \
    && pecl install mongodb \
    && docker-php-ext-enable \
        imagick \
        mcrypt \
        redis \
        mongodb \
    # Disable ImageMagick PDF security policies
    && sed -i '/^ *<!--/! s/<policy domain="coder" rights="none" pattern="PDF" \/>/<!-- <policy domain="coder" rights="none" pattern="PDF" \/> -->/' /etc/ImageMagick-6/policy.xml \
    # Delete extracted php source
    && docker-php-source delete

# Install php composer
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

COPY supervisor /etc/supervisor
COPY php/zzz-app.conf /usr/local/etc/php-fpm.d/zzz-app.conf
COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/options-ssl-nginx.conf /etc/nginx/options-ssl-nginx.conf
COPY nginx/ssl-dhparams.pem /etc/nginx/ssl-dhparams.pem
COPY nginx/nginx-site.conf /etc/nginx/sites-available/nginx-site.conf
COPY nginx/nginx-site-ssl.conf /etc/nginx/sites-available/nginx-site-ssl.conf
RUN ln -s /etc/nginx/sites-available/nginx-site.conf /etc/nginx/conf.d/nginx-site.conf

COPY nginx_default.php /var/www/html/public/nginx_default.php

COPY wait-for-it.sh /usr/local/bin/wait-for-it
RUN chmod o+x /usr/local/bin/wait-for-it

# Change memory_limit for php-cli
RUN cp /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini \
    && sed -i 's,^memory_limit =.*$,memory_limit = -1,' /usr/local/etc/php/php.ini

ENV EMAIL_FOR_SSL=saderi@gmail.com
COPY setup-ssl.sh /usr/local/bin/setup-ssl
RUN chmod o+x /usr/local/bin/setup-ssl

EXPOSE 80 443

CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]