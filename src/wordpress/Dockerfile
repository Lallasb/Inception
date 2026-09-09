FROM debian:bookworm

RUN apt update && apt install php-fpm curl  php-mysql -y

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar 
   
RUN chmod +x wp-cli.phar

RUN mv wp-cli.phar /usr/local/bin/wp

COPY   /tools/wordpress.sh  /tmp/wordpress.sh

RUN chmod +x /tmp/wordpress.sh

ENTRYPOINT ["bash","/tmp/wordpress.sh" ]

ENV SQL_DATABASE=my_first_db \
    SQL_USER=lalla \
    SQL_PASSWORD=1234 \
    SQL_ROOT_PASSWORD=12345 \
    DOMAINE_NAME=42 \
    SITE_TITLE=inseption \
    WP_ADMINE_USER=lasoubai \
    WP_ADMINE_NAME=lasouba.1337@student.com \
    WP_ADMIN_PASSWORD=12345 \
    WP_USER=lola \
    WP_USER_EMAI=lola@1337.com \
    WP_USER_PASSWORD=12345 

