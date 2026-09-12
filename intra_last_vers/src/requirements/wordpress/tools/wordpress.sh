#!/bin/bash

echo "Waiting for MariaDB..."
sleep 10
if [ ! -f /var/www/wordpress/wp-config.php ]; then
mkdir -p  /var/www/wordpress
cd /var/www/wordpress

wp core download --allow-root

wp core config --dbname=$MARIADB_DATABASE --dbuser=$MARIADB_USER \
    --dbpass=$MARIADB_PASSWORD --dbhost=$MARIADB_HOST  --allow-root --skip-check

wp core install --url=${DOMAINE_NAME} --title=$SITE_TITLE --admin_user=$WP_ADMINE_USER \
    --admin_email=$WP_ADMINE_NAME --admin_password=$WP_ADMIN_PASSWORD --allow-root

wp user create $WP_USER $WP_USER_EMAIL --user_pass=$WP_USER_PASSWORD \
    --role=author --allow-root
fi
exec php-fpm8.2 -F
