#!/bin/bash
# Checks if there's a composer.json, and if so, installs/runs composer.

set -euo pipefail

cd /opt/app

if [ -d /opt/app/sandstorm-backup-storage ] ; then
    rm -rf /opt/app/storage
    mv /opt/app/sandstorm-backup-storage /opt/app/storage
fi
if [ -d /opt/app/bootstrap/sandstorm-backup-cache ] ; then
	rm -rf /opt/app/bootstrap/cache
    mv /opt/app/bootstrap/sandstorm-backup-cache /opt/app/bootstrap/cache
fi

if [ -f /opt/app/composer.json ] ; then
    if [ ! -f composer.phar ] ; then
        curl -sS https://getcomposer.org/installer | php
    fi
    php composer.phar install --no-dev -o
fi
php composer.phar self-update

rm -f /opt/app/.env
ln -s /var/.env /opt/app/.env

# link storage folder
mv /opt/app/storage /opt/app/sandstorm-backup-storage
rm -rf /opt/app/storage
rm -rf /var/storage
ln -s /var/storage /opt/app/storage

# link bootstrap cache folder
mv /opt/app/bootstrap/cache /opt/app/bootstrap/sandstorm-backup-cache
rm -rf /opt/app/bootstrap/cache
rm -rf /var/bootstrap/cache
ln -s /var/bootstrap/cache /opt/app/bootstrap/cache