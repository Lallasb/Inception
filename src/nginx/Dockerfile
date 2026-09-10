FROM debian:bookworm

RUN apt update && apt install nginx  openssl -y
#remove list files
RUN mkdir -p /etc/nginx/ssl

RUN openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt \
    -keyout /etc/nginx/ssl/inception.key \
    -subj "/C=MA/ST=Rabat/L=Rabat/O=42/OU=42/CN=lasoubai.42.fr/UID=lasoubai"

COPY tools/nginx.conf  /etc/nginx/nginx.conf

RUN mkdir -p /run/nginx 
    # && chown -R www-data:www-data /var/www/wordpress \
    # &&  chmod 755 /var/www/wordpress
## add chown and chmod to fix


CMD ["nginx", "-g", "daemon off;"]