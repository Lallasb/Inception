FROM debian:bookworm

RUN apt update && apt install php8.2-fpm curl  php8.2-mysql -y

RUN  sed -i 's|listen = /run/php/php8.2-fpm.sock|listen = 9000|' /etc/php/8.2/fpm/pool.d/www.conf

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar 
   
RUN chmod +x wp-cli.phar

RUN mv wp-cli.phar /usr/local/bin/wp

RUN mkdir -p /run/php

COPY   /tools/wordpress.sh  /tmp/wordpress.sh

# RUN		chown -R root:root /var/www/wordpress

RUN chmod +x /tmp/wordpress.sh

ENTRYPOINT ["bash","/tmp/wordpress.sh" ]

