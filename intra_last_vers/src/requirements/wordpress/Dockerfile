FROM debian:bookworm

RUN apt update && apt install php8.2-fpm curl  php8.2-mysql -y

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar 
   
RUN chmod +x wp-cli.phar

RUN mv wp-cli.phar /usr/local/bin/wp


COPY   tools/wordpress.sh  /tmp/wordpress.sh

COPY conf/php-fpm.conf  /etc/php/8.2/fpm/pool.d/www.conf

RUN chmod +x /tmp/wordpress.sh

ENTRYPOINT ["bash","/tmp/wordpress.sh" ]

