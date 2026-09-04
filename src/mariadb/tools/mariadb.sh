!#/bin/bash

apt install service
service start mysql 
mysql -e "CREAT DATABASE \`${SQL_DATABASE}\` IF NOT EXIST;"
mysql -e "CREATE USER \`${SQL_USER}\`@`%` IF NOT EXIST IDENTIFY BY '${SQL_PASSWORD}';"
mysql -e "GARANT ALL PRIVILEGES ON \`${SQL_USER} IDENTIFY BY '${SQL_PASSWORD}';" 
mysql -e "ALTER USER 'root'@'localhost' IDENTIFY BY '${SQL_ROOT_PASSWORD}';"
mysql -e "FLUSH PRIVILEGES;"
mysqladmin -u root -p${SQL_ROOT_PASSWORD} shutdown

exec mysqld_safe

