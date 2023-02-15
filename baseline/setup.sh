#!/bin/bash

set -e
set -x

# Create users and groups
echo "nginx:x:497:495:user for nginx:/var/lib/nginx:/bin/false" >> /etc/passwd
echo "nginx:!:495:" >> /etc/group
echo "PHABRICATOR_VCS_USER:x:2000:2000:user for phabricator vcs access:/srv/phabricator:/bin/bash"  >> /etc/passwd
echo "PHABRICATOR_DAEMON_USER:x:2001:2000:user for phabricator daemons:/srv/phabricator:/bin/bash"  >> /etc/passwd
echo "wwwgrp-phabricator:!:2000:nginx,PHABRICATOR_VCS_USER,PHABRICATOR_DAEMON_USER" 		    >> /etc/group

# Install requirements
DEBIAN_FRONTEND=noninteractive apt update
DEBIAN_FRONTEND=noninteractive apt install -y git \
    php-fpm php-mbstring php-mysql php-curl  php-gd php-ldap \
    php-fileinfo php-posix php-json php-iconv php-ctype php-zip php-sockets \
    php-xmlwriter php-opcache imagemagick php-imagick php-apcu

# Set up the Phabricator code base
cd /
mkdir /srv/phabricator
cd /srv/phabricator
git clone https://we.phorge.it/source/phorge.git                        /srv/phabricator/phabricator
git clone https://we.phorge.it/source/arcanist.git                      /srv/phabricator/arcanist
git clone https://www.github.com/PHPOffice/PHPExcel.git                 /srv/phabricator/PHPExcel
git clone https://github.com/arcadien/phabricator-extensions-Sprint.git /srv/phabricator/Sprint-extension

# Hack to add direct time logging to Phrequent application
cd /srv/phabricator/phabricator
patch -p1 < /time-logging-feature.patch
rm /time-logging-feature.patch
cd /srv/phabricator/phabricator
../arcanist/bin/arc liberate -- src/
/etc/init.d/php8.1-fpm restart

# Install requirements
DEBIAN_FRONTEND=noninteractive apt update
DEBIAN_FRONTEND=noninteractive apt install -y nginx \
    python3-pygments nodejs ca-certificates \
    sudo subversion mercurial  \
    postfix locales python3-pip npm hostname certbot supervisor mariadb-client cron openssh-server

# Do not start services automatically
update-rc.d cron remove
update-rc.d postfix remove

# obsoletes? php-zlib php-openssl php-pcntl
# WebSocket library
npm install -g ws

# Remove cached things that pecl left in /tmp/
rm -rf /tmp/*
DEBIAN_FRONTEND=noninteractive apt-get clean


