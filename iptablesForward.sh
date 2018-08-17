#!/bin/sh

echo 'This script is restricted to CentOS only.'
echo "-----------------------------------------"
echo "Choice New installation,Please enter:new"
echo "-----------------------------------------"
echo "Choice Reset IP,Please enter:ip"
echo "-----------------------------------------"
echo "Choice installation bbr,Please enter:bbr"

read CHOICE

case $CHOICE in

	"ip") Reset_IP
;;
    "bbr") insetll_bbr
;;
	"new") newInstallation
;;
	 *) echo "Can't find the related server name"
	 exit
;;
esac

# get_local_ip(){
# 	LOCALIP=$(curl http://65.49.226.175:9191/reverse/clinet/get/ip?type=ip -s)
# 	return $LOCALIP
# }

################################
#Get the external network IP
################################
LOCALNETWORKIP=$(curl http://65.49.226.175:9191/reverse/clinet/get/ip?type=ip -s)

# echo "#################"
# echo $LOCALNETWORKIP

############################Reset IP###################################
Reset_IP(){
echo "################################"
echo "Start new installation"
echo "################################"
echo "Please set up according to the prompt."
echo "################################"
echo "Forwarding target IP"
echo "################################"
read RESETIP
echo "################################"
echo "Forwarding target port"
echo "################################"
read PORT
# echo "############show ip:port###############"
# echo $RESETIP':'$PORT

ulimit -n 100000
yum install -y iptables iptables-services 

echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf
sysctl -p

iptables -F && iptables -F -t nat && iptables -X

iptables -t nat -A PREROUTING -p tcp --dport $PORT -j DNAT --to-destination $RESETIP:$PORT
iptables -t nat -A POSTROUTING -p tcp -d $RESETIP --dport $PORT -j SNAT --to-source $LOCALNETWORKIP

iptables -t nat -A PREROUTING -p udp --dport $PORT -j DNAT --to-destination $RESETIP:$PORT
iptables -t nat -A POSTROUTING -p udp -d $RESETIP --dport $PORT -j SNAT --to-source $LOCALNETWORKIP

service iptables save
service iptables restart

}


###
newInstallation(){

echo "################################"
echo "Start new installation"
echo "################################"
echo "Please set up according to the prompt."
echo "################################"
echo "Forwarding target IP"
echo "################################"
read RESETIP
echo "################################"
echo "Forwarding target port"
echo "################################"
read PORT
# echo "############show ip:port###############"
# echo $RESETIP':'$PORT


systemctl stop firewalld.service
systemctl disable firewalld.service
systemctl mask firewalld
ulimit -n 100000
yum install -y iptables iptables-services 

echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf
sysctl -p

iptables -F && iptables -F -t nat && iptables -X

iptables -t nat -A PREROUTING -p tcp --dport $PORT -j DNAT --to-destination $RESETIP:$PORT
iptables -t nat -A POSTROUTING -p tcp -d $RESETIP --dport $PORT -j SNAT --to-source $LOCALNETWORKIP

iptables -t nat -A PREROUTING -p udp --dport $PORT -j DNAT --to-destination $RESETIP:$PORT
iptables -t nat -A POSTROUTING -p udp -d $RESETIP --dport $PORT -j SNAT --to-source $LOCALNETWORKIP

service iptables save && service iptables restart
systemctl enable iptables.service 
systemctl disable iptables.service

}

#####bbr 
insetll_bbr(){
	echo "################################"
	echo "insetll bbr"
	echo "################################"
	wget --no-check-certificate https://github.com/teddysun/across/raw/master/bbr.sh && chmod +x bbr.sh && ./bbr.sh
}
