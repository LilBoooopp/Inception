#!/bin/bash

SQL_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)

mkdir -p /var/www/wordpress

cd /var/www/wordpress

if [ ! -f wp-config.php ]; then
  wp config create  --allow-root \
                    --dbname=$SQL_DATABASE \
                    --dbuser=$SQL_USER \
                    --dbpass=$SQL_PASSWORD \
                    --dbpass=$SQL_HOST \
                    --path='/var/www/wordpress'
  
  wp core install --allow-root \
                  --url=$WP_URL \
                  --title=$WP_TITLE \
                  --admin_user=$WP_ADMIN_USER \
                  --admin_password=$WP_ADMIN_PASSWORD \
                  --admin_email=$WP_ADMIN_EMAIL \
                  --path='/var/www/wordpress'

  wp user create  --allow-root \
                  $WP_USER $WP_EMAIL \
                  --user_pass=$WP_PASSWORD \
                  --role=author \
                  --path='/var/www/wordpress'

fi

mkdir -p /run/php

exec /usr/sbin/php-fpm7.4 -F
