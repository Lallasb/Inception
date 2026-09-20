FROM debian:bookworm

RUN apt update && apt install mariadb-server -y

COPY tools/mariadb.sh /tmp/mariadb.sh

COPY conf/mariadb.conf  /etc/mysql/mariadb.conf.d/50-server.cnf

RUN chmod +x /tmp/mariadb.sh

ENTRYPOINT ["bash","/tmp/mariadb.sh"] 

