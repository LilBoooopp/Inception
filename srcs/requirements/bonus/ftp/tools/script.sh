#!/bin/bash

adduser --disabled-password --gecos "" $FTP_USER
echo "$FTP_USER:$FTP_PASSWORD" | chpasswd

echo "$FTP_USER" | tee -a /etc/vsftpd.userlist

mkdir -p /var/www/wordpress
chown -R $FTP_USER:$FTP_USER /var/www/wordpress

exec /usr/sbin/vsftpd /etc/vsftpd.conf
