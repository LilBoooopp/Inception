#!/bin/bash

SQL_PASSWORD=$(cat /run/secrets/db_password)
SQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)

if [ ! -d "/var/lib/mysql/${SQL_DATABASE}" ]; then
  echo "Database not found. Initializing..."

  echo "-- STARTING MARIADB SETUP --"
  service mariadb start

  echo "Waiting for Mariadb..."
  while ! mysqladmin ping -hlocalhost --silent; do
    sleep 1
  done
  echo "Mariadb UP"

  echo "Creating database: $SQL_DATABASE"
  mariadb -e "CREATE DATABASE IF NOT EXISTS $SQL_DATABASE;"
  echo "Creating user: $SQL_USER"
  mariadb -e "CREATE USER IF NOT EXISTS '$SQL_USER'@'%' IDENTIFIED BY '$SQL_PASSWORD';"
  echo "Granting privileges"
  mariadb -e "GRANT ALL PRIVILEGES ON $SQL_DATABASE.* TO '$SQL_USER'@'%';"
  mariadb -e "FLUSH PRIVILEGES;"
  echo "securing root user"
  mariadb -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$SQL_ROOT_PASSWORD';"

  echo "-- SETPU FINISHED. RESTARTING --"

  mysqladmin -u root -p$SQL_ROOT_PASSWORD shutdown
  echo "Database initialized."
else
  echo "Database already exists. Skipping..."
fi

exec mysqld_safe
