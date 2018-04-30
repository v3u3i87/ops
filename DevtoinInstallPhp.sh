#!/bin/bash


# echo "Install the selection"
# echo "Input (1) install php7.2"
# echo "Input (2) install swoole"


# read HOSTNAME

# case $HOSTNAME in

# 	"1") Install_PHP72
# ;;
# 	"2") Install_Swoole
# ;;
# 	 *) echo "Can't find the related server name"
# 	 exit
# ;;
# esac


mkdir -p /usr/devtoin/dow
mkdir -p /usr/devtoin/software
mkdir -p /usr/devtoin/software/log
# mkdir -p /usr/devtoin/etc
# mkdir -p /usr/devtoin/etc/php-fpm.d

cd /usr/devtoin/dow

#new user www in group use www the paht dir..
groupadd -r www && useradd -r -g www -s /bin/false -d /usr/devtoin/software/php -M www

#new user devtoin in group use devtoin
groupadd -r devtoin && useradd -r -g devtoin -s /bin/false -d

yum install epel-release -y
yum  -y update
yum -y install gcc gcc-c++ make cmake automake autoconf m4 kernel-devel ncurses-devel libxml2-devel openssl openssl-devel libicu libicu-devel curl-devel libjpeg-devel libpng-devel pcre pcre-devel libtool-libs freetype-devel gd zlib-devel file bison patch mlocate flex diffutils readline-devel glibc-devel glib2-devel bzip2-devel gettext-devel libcap-devel libmcrypt-devel openldap openldap-devel libxslt-devel libtidy-devel libtidy vim


#set php version
phpVersion='7.2.5'

wget -O php-$phpVersion.tar.gz http://cn2.php.net/get/php-$phpVersion.tar.gz/from/this/mirror

tar zxvf php-$phpVersion.tar.gz && cd php-$phpVersion

#线程安全模式 --enable-maintainer-zts
./configure  --prefix=/usr/devtoin/software/php \
--with-config-file-path=/usr/devtoin/software/php/etc \
--with-config-file-scan-dir=/usr/devtoin/software/php/conf.d \
--enable-fpm \
--with-fpm-user=www \
--with-fpm-group=www \
--with-libxml-dir \
--enable-xml \
--with-mysqli=mysqlnd \
--with-pdo-mysql=mysqlnd \
--with-iconv-dir \
--with-jpeg-dir \
--with-png-dir \
--with-freetype-dir \
--with-zlib \
--with-openssl \
--with-curl \
--disable-rpath \
--enable-bcmath \
--enable-shmop \
--enable-sysvsem \
--enable-inline-optimization  \
--enable-mbregex \
--enable-mbstring \
--enable-intl \
--enable-ftp \
--with-libmbfl \
--with-gd \
--with-mhash \
--enable-pcntl \
--enable-sockets \
--with-xmlrpc \
--with-libzip \
--enable-soap \
--with-gettext  \
--disable-fileinfo \
--enable-opcache \
--with-xsl \
--with-pear \
--without-gdbm

make
echo "=====make install======="
make install

echo "Copy new php configure file..."
#mkdir -p /usr/devtoin/software/php/conf.d

\cp php.ini-production /usr/devtoin/software/php/etc/php.ini
# \cp /usr/devtoin/software/php/etc/php-fpm.conf.default /usr/devtoin/software/php/etc/php-fpm.conf
# \cp /usr/devtoin/software/php/etc/php-fpm.d/www.conf.default /usr/devtoin/software/php/etc/php-fpm.d/www.conf

# phpINI='/usr/devtoin/software/php/etc/php.ini'

#make test
cd /usr/devtoin/software/php/etc

# php extensions 
echo "Modify php.ini......"
sed -i 's/expose_php =.*/expose_php = Off/g' /usr/devtoin/software/php/etc/php.ini
sed -i 's/post_max_size =.*/post_max_size = 50M/g' /usr/devtoin/software/php/etc/php.ini
sed -i 's/upload_max_filesize =.*/upload_max_filesize = 50M/g' /usr/devtoin/software/php/etc/php.ini
sed -i 's/memory_limit =.*/memory_limit = 128M/g' /usr/devtoin/software/php/etc/php.ini
sed -i 's/max_input_time =.*/max_input_time = 300/g' /usr/devtoin/software/php/etc/php.ini
sed -i 's/;date.timezone =.*/date.timezone = PRC/g' /usr/devtoin/software/php/etc/php.ini
sed -i 's/short_open_tag =.*/short_open_tag = On/g' /usr/devtoin/software/php/etc/php.ini
sed -i 's/;cgi.fix_pathinfo=.*/cgi.fix_pathinfo=0/g' /usr/devtoin/software/php/etc/php.ini
sed -i 's/max_execution_time =.*/max_execution_time = 300/g' /usr/devtoin/software/php/etc/php.ini

#sed -i 's/disable_functions =.*/disable_functions = passthru,exec,system,chroot,chgrp,chown,shell_exec,proc_open,proc_get_status,popen,ini_alter,ini_restore,dl,openlog,syslog,readlink,symlink,popepassthru,stream_socket_server/g' /usr/local/php/etc/php.ini

#set opcache
# [opcache]
# zend_extension=/usr/devtoin/software/php/lib/php/extensions/no-debug-zts-20160303/opcache.so
# opcache.memory_consumption=128
# opcache.interned_strings_buffer=8
# opcache.max_accelerated_files=4000
# opcache.revalidate_freq=60
# opcache.fast_shutdown=1
# opcache.enable_cli=1

# Install_Composer

echo "Install ZendGuardLoader for PHP 7.x..."
echo "unavailable now."

# expose_php = Off
# short_open_tag = ON
# max_execution_time = 300
# max_input_time = 300
# memory_limit = 128M
# post_max_size = 32M
# date.timezone = Asia/Shanghai
# extension = "/usr/local/php/lib/php/extensions/no-debug-zts-20160303/ldap.so"


echo "Creating new php-fpm configure file..."
cat >/usr/devtoin/software/php/etc/php-fpm.conf<<EOF
	[global]
	pid = /usr/devtoin/software/php/var/run/php-fpm.pid
	error_log = /usr/devtoin/software/log/php-fpm.log
	log_level = notice
	[www]
	listen = /tmp/php-cgi.sock
	listen.backlog = -1
	listen.allowed_clients = 127.0.0.1
	listen.owner = www
	listen.group = www
	listen.mode = 0666
	user = www
	group = www
	pm = dynamic
	pm.max_children = 10
	pm.start_servers = 2
	pm.min_spare_servers = 1
	pm.max_spare_servers = 6
	request_terminate_timeout = 100
	request_slowlog_timeout = 0
	slowlog = /usr/devtoin/software/log/php-slow.log
EOF

#创建php-cgi.sock存放目录
echo "############################################"
echo "Create php-cgi. Sock storage directory...."
echo "############################################"
mkdir -p /var/run/www/
chown -R www:www /var/run/www

echo "set system start"

cat >/usr/lib/systemd/system/php-fpm.service<<EOF
	[Unit]
	Description=The PHP FastCGI Process Manager
	After=syslog.target network.target

	[Service]
	Type=simple
	PIDFile=/usr/devtoin/software/php/var/run/php-fpm.pid
	ExecStart=/usr/devtoin/software/php/sbin/php-fpm --nodaemonize --fpm-config /usr/devtoin/software/php/etc/php-fpm.conf
	ExecReload=/bin/kill -USR2 $MAINPID

	[Install]
	WantedBy=multi-user.target
EOF

#默认不启动php-fpm
#systemctl start php-fpm.service
#systemctl enable php-fpm.service
#systemctl restart php-fpm.service

echo "set The environment variable"

#添加php的环境变量
# echo -e '\nexport PATH=/usr/devtoin/software/php/bin:/usr/devtoin/software/php/sbin:$PATH\n' >> /etc/profile && source /etc/profile
# echo -e '\nexport PATH=/usr/devtoin/software/php/bin:/usr/devtoin/software/php/sbin:$PATH\n' >> /etc/bashrc && source /etc/bashrc

echo -e '\nexport PATH=/usr/devtoin/software/php/bin:/usr/devtoin/software/php/sbin:$PATH\n' >> /etc/bashrc 


############################历史笔记###################################
# #######设置PHP日志目录和php-fpm的运行进程ID文件（php-fpm.sock）目录
# mkdir -p /var/log/php-fpm
# mkdir -p /var/run/php-fpm 
# cd /var/run/ && chown -R www:www php-fpm
# #######修改session的目录配置
# mkdir -p /var/lib/php/session 
# chown -R www:www /var/lib/php

# #添加执行权限
# chmod +x /etc/rc.d/init.d/php-fpm 

#设置启动相关
# chkconfig --add php-fpm
# #设置开机启动
# chkconfig php-fpm on
# #检查是否合法
# php-fpm -t
# #启动
# service php-fpm start
############################历史笔记###################################



Install_Swoole()
{
############################swoole in install ###################################
echo "################################"
echo "swoole in install "
echo "################################"
sV='1.10.4'
wget https://github.com/swoole/swoole-src/archive/v$sV.tar.gz
tar zxvf v$sV.tar.gz
cd swoole-src-$sV
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
}

#安装Composer
Install_Composer()
{
    curl -sS --connect-timeout 30 -m 60 https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
    if [ $? -eq 0 ]; then
    	chmod +x /usr/local/bin/composer
        echo "Composer install successfully."
    else
    	echo "############################################"
		echo "Composer install failed!"
		echo "############################################"

        # if [ -s /usr/local/php/bin/php ]; then
        #     wget --prefer-family=IPv4 --no-check-certificate -T 120 -t3 ${Download_Mirror}/web/php/composer/composer.phar -O /usr/local/bin/composer
        #     if [ $? -eq 0 ]; then
        #         echo "Composer install successfully."
        #     else
        #         echo "Composer install failed!"
        #     fi
        #     chmod +x /usr/local/bin/composer
        # fi
    fi
}

