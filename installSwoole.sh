#!/bin/bash

############################swoole in install ###################################
echo "################################"
echo "swoole in install "
echo "################################"
SWOOLE_VERSION='1.10.5'
wget https://github.com/swoole/swoole-src/archive/v$SWOOLE_VERSION.tar.gz
tar zxvf v$SWOOLE_VERSION.tar.gz
cd swoole-src-$SWOOLE_VERSION
phpize
./configure

echo "start make install"
make && make install 
echo "end make install"

echo -e "extension=swoole.so\n" >> /usr/devtoin/software/php/etc/php.ini

#重起php
#systemctl restart php-fpm.service
#查看swoole 版本命令

echo "Make PHP effective in the environment: source /etc/bashrc"
echo "Check the swoole: php --ri swoole"