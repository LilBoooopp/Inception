FROM debian:bookworm

RUN apt-get update && apt-get install -y nginx openssl 

RUN mkdir -p /etc/nginx/ssl
RUN openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj "/C=CH/ST=Vaud/L=Lausanne/O=42/OU=42L/CN=cbopp.42.fr/UID=cbopp"

COPY conf/nginx.conf /etc/nginx/nginx.conf

RUN mkdir -p /var/www/wordpress
RUN chmod 755 /var/www/wordpress
RUN chown -R www-data:www-data /var/www/wordpress

CMD ["nginx", "-g", "daemon off;"]
