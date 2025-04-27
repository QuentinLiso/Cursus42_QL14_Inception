FROM	debian:bullseye

RUN	apt-get -y update && apt-get -y upgrade
RUN	apt-get -y install wget curl
RUN	apt-get -y install php php-fpm php-mysql mariadb-client redis-tools

RUN	mkdir -p /run/php
RUN	mkdir -p /var/www/html && chown -R www-data:www-data /var/www

RUN	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN	chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

WORKDIR	/var/www/html
RUN	wp core download --allow-root
RUN	chown -R www-data:www-data /var/www/html
RUN	chmod -R 755 /var/www
COPY 	conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

EXPOSE	9000

COPY	tools/setup_wp.sh /usr/local/bin/setup_wp.sh
RUN	chmod +x /usr/local/bin/setup_wp.sh

CMD ["setup_wp.sh"]
