#!/bin/bash


if [ ! -d "/var/lib/mysql/${MARIADB_DATABASE}" ]; then

service mariadb start 

until mysqladmin ping >/dev/null 2>&1; do
        sleep 1
    done

mysql -e "CREATE DATABASE IF NOT EXISTS \`${MARIADB_DATABASE}\` ;"
mysql -e "CREATE USER IF NOT EXISTS \`${MARIADB_USER}\`@'%'  IDENTIFIED BY '${MARIADB_PASSWORD}';"
mysql -e "GRANT ALL PRIVILEGES ON \`${MARIADB_DATABASE}\`.* TO '${MARIADB_USER}'@'%';" 
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MARIADB_ROOT_PASSWORD}';"
mysql -u root -p"${MARIADB_ROOT_PASSWORD}" -e "FLUSH PRIVILEGES;"
mysqladmin -u root -p"${MARIADB_ROOT_PASSWORD}" shutdown

fi

exec mysqld_safe
