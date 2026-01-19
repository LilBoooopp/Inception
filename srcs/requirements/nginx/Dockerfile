FROM debian:bookworm

RUN apt-get update && apt-get install -y nginx openssl 

RUN mkdir -p /etc/nginx/ssl
RUN openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj
