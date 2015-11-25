# For running the latest ampache directly from the repository

FROM php:apache

MAINTAINER PlusMinus <piddlpiddl@gmail.com>


# Install everything
# For installing ffmpeg, the deb-multimedia repository is used which might be considered unsafe so use with caution
RUN echo deb http://www.deb-multimedia.org jessie main non-free >> /etc/apt/sources.list \
                        && apt-get update && apt-get install -y --force-yes -q deb-multimedia-keyring \
                        && apt-get update && apt-get install -y -q git ffmpeg \
                        && docker-php-ext-install pdo_mysql\
                        && cd /var/www   \
                        && git clone https://github.com/ampache/ampache.git \
                        && mv ampache/* html/ \
                        && rm -r ampache \
                        && rm -rf /tmp/* /var/tmp/*  \
                        && rm -rf /var/lib/apt/lists/* \
                        && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
                        && cd html \
                        && composer install --prefer-source --no-interaction \
                        && apt-get remove -y git \
                        && apt-get autoremove -y \
                        && apt-get clean \
                        && mkdir -p /var/data \
                        && chown -R www-data:www-data /var/www/html

VOLUME ["/var/www/html/config","/var/www/html/themes","/var/data"]

CMD ["apache2-foreground"]

