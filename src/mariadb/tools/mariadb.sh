#!/bin/bash


service mariadb start  
mysql -e "CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\` ;"
mysql -e "CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'%'  IDENTIFIED BY '${SQL_PASSWORD}';"
mysql -e "GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO '${SQL_USER}'@'%';" 
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"
mysql -e "FLUSH PRIVILEGES;"
mysqladmin -u root -p"${SQL_ROOT_PASSWORD}" shutdown

# exec mysqld_safe
exec bash



# # #!/bin/bash

# # Ensure socket directory exists on runtime
# mkdir -p /run/mysqld
# chown -R mysql:mysql /run/mysqld

# # Check if database setup was already initialized
# if [ ! -d "/var/lib/mysql/${SQL_DATABASE}" ]; then

#     service mariadb start  

#     until mysqladmin ping >/dev/null 2>&1; do
#         sleep 1
#     done

#     mysql -e "CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;"
#     mysql -e "CREATE USER IF NOT EXISTS '${SQL_USER}'@'%' IDENTIFIED BY '${SQL_PASSWORD}';"
#     mysql -e "GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO '${SQL_USER}'@'%';" 
#     mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"
#     mysql -e "FLUSH PRIVILEGES;"

#     mysqladmin -u root -p"${SQL_ROOT_PASSWORD}" shutdown
# fi

# # Launch PID 1 process
# exec mysqld_safe