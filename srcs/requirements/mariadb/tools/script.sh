#!/bin/bash

if [ ! -d "/var/liv/mysql/${SQL_DATABASE}" ]; then
  echo "Database not found. Initializing..."

  service mariadb start

  while ! mysqladmin ping -hlocalhost --silent; do
    sleep 1
  done

  mariadb -e "CREATE DATABASE IF NOT EXIST \'${SQL_DATABASE}\`;"
  mariadb -e "CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'localhost' IDENTIFIED BY '${SQL_PASSWORD}';"
  mariadb -e "GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';"
  mariadb -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"
  mariadb -e "FLUSH PRIVILEGES;"

  mysqladmin -u root -p$SQL_ROOT_PASSWORD shutdown
  echo "Database initialized."
else
  echo "Database already exists. Skipping..."
fi

exec mysqld_safe
