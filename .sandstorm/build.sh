#!/bin/bash

set -euo pipefail

cd /opt/app

# remove any symlinks we created
if [ -d /opt/app/sandstorm-backup-storage ] ; then
    rm -rf /opt/app/storage
    mv /opt/app/sandstorm-backup-storage /opt/app/storage
fi
if [ -d /opt/app/sandstorm-backup-bootstrap ] ; then
    rm -rf /opt/app/bootstrap
    mv /opt/app/sandstorm-backup-bootstrap /opt/app/bootstrap
fi
if [ -d /opt/app/public/sandstorm-backup-logo ] ; then
    rm -rf /opt/app/public/logo
    mv /opt/app/public/sandstorm-backup-logo /opt/app/public/logo
fi

# link env file
rm -f /opt/app/.env
ln -s /var/.env /opt/app/.env

# link storage folder
mv /opt/app/storage /opt/app/sandstorm-backup-storage
rm -rf /opt/app/storage
rm -rf /var/storage
ln -s /var/storage /opt/app/storage

# link bootstrap folder
mv /opt/app/bootstrap /opt/app/sandstorm-backup-bootstrap
rm -rf /opt/app/bootstrap
rm -rf /var/bootstrap
ln -s /var/bootstrap /opt/app/bootstrap

# link public logo folder
mv /opt/app/public/logo /opt/app/public/sandstorm-backup-logo
rm -rf /opt/app/public/logo
rm -rf /var/public/logo
ln -s /var/public/logo /opt/app/public/logo