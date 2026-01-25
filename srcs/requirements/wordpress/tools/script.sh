#!/bin/bash

mkdir -p /run/php

sleep 10

cd /var/www/wordpress

# check if wp is there
if [ ! -f wp-config.php ]; then
  # if the folder is empty, download wp again
  if [ ! -f index.php ]; then
    wp core download --allow-root
  fi

  SQL_PASSWORD=$(cat /run/secrets/db_password)
  WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)

  # configure connection
  wp config create  --allow-root \
                    --dbname=$SQL_DATABASE \
                    --dbuser=$SQL_USER \
                    --dbpass=$SQL_PASSWORD \
                    --dbhost=$SQL_HOST \
                    --path='/var/www/wordpress'
  
  # install site
  wp core install --allow-root \
                  --url=$WP_URL \
                  --title=$WP_TITLE \
                  --admin_user=$WP_ADMIN_USER \
                  --admin_password=$WP_ADMIN_PASSWORD \
                  --admin_email=$WP_ADMIN_EMAIL \
                  --path='/var/www/wordpress'

  # create user
  wp user create  --allow-root \
                  $WP_USER $WP_EMAIL \
                  --user_pass=$WP_PASSWORD \
                  --role=author \
                  --path='/var/www/wordpress'

fi

exec /usr/sbin/php-fpm8.2 -F
