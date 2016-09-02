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
cp -nR /opt/app/sandstorm-backup-storage /var/storage
mkdir -p /var/bootstrap
mkdir -p /var/bootstrap/cache
cp -nR /opt/app/sandstorm-backup-bootstrap /var/bootstrap
mkdir -p /var/public
mkdir -p /var/public/logo
cp -nR /opt/app/public/sandstorm-backup-logo /var/public/logo
cp -n /opt/app/.env.example /var/.env

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
