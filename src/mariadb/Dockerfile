FROM debian:bookworm

RUN apt update && apt install mariadb-server -y

COPY tools/mariadb.sh /mariadb.sh

COPY tools/mariadb.cnf /etc/mysql/mariadb_conf/50-server

ENTRYPOINT ["mariadb.sh"]