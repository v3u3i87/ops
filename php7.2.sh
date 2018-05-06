#!/bin/bash

wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
wget http://rpms.remirepo.net/enterprise/remi-release-7.rpm
#导入Remi包
rpm -Uvh remi-release-7.rpm epel-release-latest-7.noarch.rpm

tee /etc/yum.repos.d/nginx.repo <<-'EOF'
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/$releasever/$basearch/
gpgcheck=0
enabled=1
EOF

yum --enablerepo=remi -y update 

yum --enablerepo=remi,remi-php72 -y install nginx php-fpm php-common

yum --enablerepo=remi,remi-php72 -y install php-opcache php-pecl-apcu php-cli php-pear php-pdo php-mysqlnd php-pgsql php-pecl-mongodb php-pecl-redis php-pecl-memcache php-pecl-memcached php-gd php-mbstring php-mcrypt php-xml php-devel