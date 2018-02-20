FROM php:7.0-apache

# Use custom php ini file
COPY php.ini /usr/local/etc/php/

# Install dependencies
RUN apt-get update
RUN apt-get install -y zip curl vim
RUN apt-get install -y libmcrypt-dev
RUN apt-get install -y libmagickwand-dev imagemagick
RUN apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libpng12-dev

RUN apt-get install -y libicu-dev \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl
RUN docker-php-ext-install pdo_mysql 
RUN docker-php-ext-install mysqli 
RUN docker-php-ext-install iconv
RUN docker-php-ext-install zip
RUN apt-get install libcurl3-dev libcurl4-openssl-dev \
    && docker-php-ext-install curl 
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ 
RUN docker-php-ext-install -j$(nproc) gd

RUN pecl install imagick
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

EXPOSE 80 443 3306

ENTRYPOINT service apache2 restart && bash

