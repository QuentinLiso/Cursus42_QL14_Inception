#!/bin/bash

cat > /tmp/ping.cnf << EOF
[client]
user = ${DB_ADMIN_USER}
password = ${DB_ADMIN_PASS}
host = ${DB_HOST}
EOF

#until mysqladmin ping -h ${DB_HOST} --silent; do
until mysqladmin --defaults-extra-file=/tmp/ping.cnf ping --silent; do
	echo "Waiting for MariaDB..."
	sleep 2
done

rm -rf /tmp/ping.cnf

if ! wp core is-installed --allow-root; then
wp config create \
	--dbname=${DB_NAME} \
	--dbuser=${DB_ADMIN_USER} \
	--dbpass=${DB_ADMIN_PASS} \
	--dbhost=${DB_HOST} \
	--path=/var/www/html \
	--allow-root

wp core install \
	--url="https://localhost" \
	--title="QLISO website" \
	--admin_user=${WP_ADMIN_USER} \
	--admin_password=${WP_ADMIN_PASS} \
	--admin_email=${WP_ADMIN_MAIL} \
	--skip-email \
	--path=/var/www/html \
	--allow-root

wp user create ${WP_LAMBDA_USER} ${WP_LAMBDA_MAIL} \
	--role=editor \
	--user_pass=${WP_LAMBDA_PASS} \
	--allow-root
fi


if ! wp plugin is-installed redis-cache --allow-root; then
	wp plugin install redis-cache --activate --allow-root
else
	wp plugin activate redis-cache --allow-root
fi

if ! wp config get WP_REDIS_HOST --allow-root > /dev/null 2>&1; then
	wp config set WP_REDIS_HOST ${WP_REDIS_HOST} --allow-root
fi

if ! wp config get WP_REDIS_PORT --allow-root > /dev/null 2>&1; then
	wp config set WP_REDIS_PORT ${WP_REDIS_PORT} --raw --allow-root
fi


until redis-cli -h ${WP_REDIS_HOST} ping | grep -q PONG; do
	echo "Waiting for Redis..."
	sleep 2
done

if ! wp redis status --allow-root | grep -q "Status: Connected"; then
	wp redis enable --allow-root
fi

php-fpm7.4 -F
