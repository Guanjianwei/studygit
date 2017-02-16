#!/bin/bash   

##By GUAN##20170113
#优化
#===selinux===
sed -i 's/SELINUX=enforcing/SELINUX=disabled/ ' /etc/selinux/config
setenforce 0
# 开启eth0
sed -i s/no/yes/  /etc/sysconfig/network-scripts/ifcfg-eth0
#=== SSHD ==
sed -i '$a UseDNS no' /etc/ssh/sshd_config

#== Alias ==
cat >> ~/.bashrc <<EOF
alias grep='grep --color '
HISTTIMEFORMAT="%F %T "
HISTSIZE=1000
EOF
. /root/.bashrc
##====yum 源
yum install -y wget curl dos2unix iotop sysstat  tcpdump lrzsz epel-release vim htop

mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-6.repo
yum install -y epel-release
wget -O /etc/yum.repos.d/epel.repo  http://mirrors.aliyun.com/repo/epel.repo
yum clean all
yum makecache

##
#取消tab声音
#vim /etc/inputrc  去掉 “set bell-style none”前面的#号
sed -i '/bell-style/a\set bell-style none' /etc/inputrc
#vim打开文档时显示行号   vim /etc/vimrc   添加set number
sed -i '$a set number' /etc/vimrc





