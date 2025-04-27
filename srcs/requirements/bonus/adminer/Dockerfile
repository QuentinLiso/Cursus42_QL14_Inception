FROM debian:bullseye

RUN apt-get update -y && apt-get install -y \
	php \
	php-fpm \
	php-mysqli \
	curl

RUN mkdir -p /run/php && chown -R www-data:www-data /run/php
RUN mkdir -p /var/www/html && chown -R www-data:www-data /var/www && chown -R www-data:www-data /var/www/html
RUN chmod -R 755 /var/www

WORKDIR /var/www/html
RUN	curl -L -o /var/www/html/index.php https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php

COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

EXPOSE 9000

CMD ["php-fpm7.4", "-F"]
