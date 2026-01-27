#!/bin/bash

FTP_PASSWORD=$(cat /run/secrets/ftp_password)

adduser --disabled-password --gecos "" --home /var/www/wordpress --no-create-home $FTP_USER
echo "$FTP_USER:$FTP_PASSWORD" | chpasswd

echo "$FTP_USER" | tee -a /etc/vsftpd.userlist

mkdir -p /var/www/wordpress/
chown -R $FTP_USER:$FTP_USER /var/www/wordpress/

mkdir -p /var/run/vsftpd/empty

exec /usr/sbin/vsftpd /etc/vsftpd.conf
