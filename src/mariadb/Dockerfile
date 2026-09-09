FROM debian:bookworm

RUN apt update && apt install mariadb-server -y

COPY tools/mariadb.sh mariadb.sh

COPY tools/mariadb.conf  /etc/mysql/mariadb.conf.d/50-server.cnf

ENV SQL_DATABASE=my_first_db \
    SQL_USER=lalla \
    SQL_PASSWORD=1234 \
    SQL_ROOT_PASSWORD=12345

RUN chmod +x mariadb.sh

ENTRYPOINT ["bash","mariadb.sh"] 


# FROM debian:bookworm

# RUN apt-get update && apt-get install -y mariadb-server && \
#     rm -rf /var/lib/apt/lists/*

# # Create socket directory and set proper permissions
# RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld

# COPY tools/mariadb.sh /mariadb.sh
# COPY tools/mariadb.conf /etc/mysql/mariadb.conf.d/50-server.cnf

# RUN chmod +x /mariadb.sh

# ENV SQL_DATABASE=my_first_db \
#     SQL_USER=lalla \
#     SQL_PASSWORD=1234 \
#     SQL_ROOT_PASSWORD=12345

# ENTRYPOINT ["/bin/bash", "/mariadb.sh"]