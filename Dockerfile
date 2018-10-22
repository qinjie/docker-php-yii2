FROM php:7.2-apache

# Use custom php ini file
COPY php.ini /usr/local/etc/php/

# Install system packages for PHP extensions recommended for Yii 2.0 Framework
RUN apt-get update && \
    apt-get -y install \
        gnupg2 && \
    apt-get update && \
    apt-get -y install \
            g++ \
            git \
            curl \
            apt-utils \
            apt-transport-https \
            libmcrypt-dev \
            libfreetype6-dev \
            libcurl3-dev \
            libjpeg-dev \
            libjpeg62-turbo-dev \
            libpq-dev \
            libpng-dev \
            libxml2-dev \
            zlib1g-dev \
            mysql-client \
            openssh-client \
            nano \
            unzip \
            vim \
        --no-install-recommends 

RUN apt-get install -y libicu-dev \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl

RUN docker-php-ext-install \
        soap \
        zip \
        bcmath \
        exif \
        iconv \
        mbstring \
        opcache \
        mysqli \
        pdo_mysql \
        pdo_pgsql

RUN apt-get install -y libgmp-dev \
    && ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/local/include/ \
    && docker-php-ext-configure gmp \
    && docker-php-ext-install gmp

#RUN docker-php-ext-configure mcrypat \
#    && docker-php-ext-install mcrypt

RUN apt-get install libcurl3-dev libcurl4-openssl-dev \
    && docker-php-ext-install curl

RUN docker-php-ext-configure bcmath \
    && docker-php-ext-install  bcmath

RUN docker-php-ext-configure gd \
        --with-freetype-dir=/usr/include/ \
        --with-png-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ \
    &&  docker-php-ext-install gd

RUN apt-get install -y libmagickwand-dev imagemagick \
    && pecl install imagick \
    && docker-php-ext-enable imagick

RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Enable apache mods.
RUN a2enmod rewrite

# Apache conf
# to see live logs we do : docker logs -f [CONTAINER ID]
# without the following line we get "AH00558: apache2: Could not reliably determine the server's fully qualified domain name"
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# autorise .htaccess files
RUN sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

# Package sites into image
COPY ./html/ /var/www/html/
RUN chown -R www-data:www-data /var/www/html/

# Copy site config for sub-domain sites
COPY ./sites-available/ /etc/apache2/sites-available/

# Change timezon setting
RUN echo "Asia/Singapore" > /etc/timezone

# Open ports
EXPOSE 80 443 3306

# ENTRYPOINT service apache2 restart && bash
EXPOSE 80
CMD apachectl -D FOREGROUND
