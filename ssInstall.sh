#!/bin/bash

cd /usr/local/src

yum -y update
wget -qO- https://raw.githubusercontent.com/v3u3i87/ops/master/gitInstall.sh | bash && source /etc/bashrc && git --version

yum install python-setuptools && easy_install pip
pip install --upgrade pip
pip install git+https://github.com/shadowsocks/shadowsocks.git@master
pip install shadowsocks


#读取外网 IP: curl -s ipecho.net/plain;echo

#多用户配置
#touch /etc/shadowsocks.json

cat >/etc/shadowsocks.json <<EOF
{
 "server":"0.0.0.0",
 "local_address": "127.0.0.1",
 "local_port":1080,
  "port_password": {
     "9933": "9933##111"
 },
 "timeout":300,
 "method":"aes-256-cfb",
 "fast_open": false
}
EOF

#设置自启
echo -e "/usr/bin/ssserver  -c /etc/shadowsocks.json -d start \n" >> /etc/rc.local

chmod +x /etc/rc.d/rc.local

/usr/bin/ssserver -c /etc/shadowsocks.json -d start