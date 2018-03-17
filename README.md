# ops

## 安装git2.9.5

````text

wget -qO- https://raw.githubusercontent.com/v3u3i87/ops/master/gitInstall.sh | bash && source /etc/bashrc && git --version

````

## 安装SS, 仅限cenots7 

````text

wget -qO- https://raw.githubusercontent.com/v3u3i87/ops/master/ssInstall.sh | bash

````


## 安装php7.2.x, 仅限cenots7 
```text

wget -qO- https://raw.githubusercontent.com/v3u3i87/ops/master/php7.2.3.devtoin-install.sh | bash

```

#建议安装screen,避免网络抖动
yum -y install screen

##创建一个screen
screen -S logInstall

##恢复会话
screen -r logInstall

##当前进行的会话
screen -ls

#mac 快捷健

##退出会话
control +a +d 