FROM debian:bookworm

RUN apt update && apt install nginx  openssl   -y

RUN mkdir -p /etc/nginx/ssl

RUN openssl req -x509 -nodes -newkey rsa:2048 -out /etc/nginx/ssl/inception.crt \
    -keyout /etc/nginx/ssl/inception.key \
    -subj "/C=MA/ST=Rabat/L=Rabat/O=42/OU=42/CN=lasoubai.42.fr/UID=lasoubai"

COPY conf/nginx.conf  /etc/nginx/nginx.conf

CMD ["nginx", "-g", "daemon off;"]