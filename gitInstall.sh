#!/bin/bash

cd /usr/local/src

version='2.9.5'

yum install -y gcc
yum install -y gcc-c++
yum install -y curl-devel expat-devel gettext-devel openssl-devel zlib-devel
yum install -y gcc perl-ExtUtils-MakeMaker autoconf tk perl cpio

yum remove -y git

cd /usr/local/src

wget https://www.kernel.org/pub/software/scm/git/git-$version.tar.gz

tar -zxvf git-$version.tar.gz

cd git-$version

./configure --prefix=/usr/local/git

make && make install
printf "\n"
echo "export PATH=$PATH:/usr/local/git/bin" >> /etc/bashrc
