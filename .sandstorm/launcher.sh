#!/bin/bash

# Create a bunch of folders under the clean /var that php, nginx, and mysql expect to exist
mkdir -p /var/lib/mysql
mkdir -p /var/lib/nginx
mkdir -p /var/lib/php5/sessions
mkdir -p /var/log
mkdir -p /var/log/mysql
mkdir -p /var/log/nginx
# Wipe /var/run, since pidfiles and socket files from previous launches should go away
# TODO someday: I'd prefer a tmpfs for these.
rm -rf /var/run
mkdir -p /var/run
mkdir -p /var/run/mysqld

# move storage folders which must be writable to /var
mkdir -p /var/storage
mkdir -p /var/storage/app
mkdir -p /var/storage/debugbar
mkdir -p /var/storage/framework
mkdir -p /var/storage/framework/cache
mkdir -p /var/storage/framework/sessions
mkdir -p /var/storage/framework/views
mkdir -p /var/storage/logs
mkdir -p /var/storage/templates
cp -nR /opt/app/sandstorm-backup-storage/* /var/storage/
mkdir -p /var/bootstrap
mkdir -p /var/bootstrap/cache
cp -nR /opt/app/bootstrap/sandstorm-backup-cache/* /var/bootstrap/cache/
mkdir -p /var/public
mkdir -p /var/public/logo
cp -nR /opt/app/public/sandstorm-backup-logo/* /var/public/logo/
cp -n /opt/app/.env.example /var/.env

# create symlinks for php files inside the bootstrap cache folder
rm -rf /var/app
rm -rf /var/config
rm -rf /var/database
rm -rf /var/resources
rm -rf /var/vendor
rm -rf /var/bootstrap/app.php
rm -rf /var/bootstrap/autoload.php
rm -rf /var/bootstrap/environment.php
rm -rf /var/artisan
rm -rf /var/c3.php
rm -rf /var/server.php
ln -s /opt/app/app /var/app
ln -s /opt/app/config /var/config
ln -s /opt/app/database /var/database
ln -s /opt/app/resources /var/resources
ln -s /opt/app/vendor /var/vendor
ln -s /opt/app/bootstrap/app.php /var/bootstrap/app.php
ln -s /opt/app/bootstrap/autoload.php /var/bootstrap/autoload.php
ln -s /opt/app/bootstrap/environment.php /var/bootstrap/environment.php
ln -s /opt/app/artisan /var/artisan
ln -s /opt/app/c3.php /var/c3.php
ln -s /opt/app/server.php /var/server.php

#chmod 777 /var/storage -R
#chmod 777 /var/bootstrap -R
#chmod 777 /var/public -R

# Cleanup log files
FILES="$(find /var/log -name '*.log')"
for f in $FILES
do
  tail $f | tee $f
done

# Ensure mysql tables created
HOME=/etc/mysql /usr/bin/mysql_install_db --force

# Spawn mysqld, php
HOME=/etc/mysql /usr/sbin/mysqld &
/usr/sbin/php5-fpm --nodaemonize --fpm-config /etc/php5/fpm/php-fpm.conf &
# Wait until mysql and php have bound their sockets, indicating readiness
while [ ! -e /var/run/mysqld/mysqld.sock ] ; do
    echo "waiting for mysql to be available at /var/run/mysqld/mysqld.sock"
    sleep .2
done
while [ ! -e /var/run/php5-fpm.sock ] ; do
    echo "waiting for php5-fpm to be available at /var/run/php5-fpm.sock"
    sleep .2
done

# Ensure the database exists.
echo "CREATE DATABASE IF NOT EXISTS ninja DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci; GRANT ALL PRIVILEGES ON ninja.* TO 'ninja'@'localhost' IDENTIFIED BY 'ninja' WITH GRANT OPTION; FLUSH PRIVILEGES;" | mysql --user root --socket /var/run/mysqld/mysqld.sock
# Run database migrations.
time php /opt/app/artisan key:generate
time php /opt/app/artisan migrate --seed --force

# Start nginx.
/usr/sbin/nginx -c /opt/app/.sandstorm/service-config/nginx.conf -g "daemon off;"
