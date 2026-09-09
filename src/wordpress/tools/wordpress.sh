#!/bin/bash


sleep 10
mkdir -p  /var/www/wordpress
cd /var/www/wordpress

wp core download --allow-root

wp core config --dbname=$DOMAINE_NAME --dbuser=$SQL_USER \
    --dbpass=$SQL_PASSWORD --dbhost=$SQL_HOST  --allow-root --skip-check

wp core install --url=$$DOMAINE_NAME --title=$SITE_TITLE --admin_user=$WP_ADMINE_USER \
    --admine_email=$WP_ADMINE_NAME --admin_password=$WP_ADMIN_PASSWORD --allow-root

wp user create $WP_USER $WP_USER_EMAIL --user_pass=$WP_USER_PASSWORD \
    --role=author --allow-root

# /usr/sbin/php-fpm -F
exec bash