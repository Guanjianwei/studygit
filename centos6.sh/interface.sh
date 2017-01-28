# 用于copyi centos6 虚拟机后更改网卡错误 --version 1.0
# By  GUAN
#网卡配置文件路径
w1='/etc/udev/rules.d/70-persistent-net.rules'

#获取需要更改的网卡名及对应关系
dmesg|grep eth |grep to|awk '{print $(NF-2),$NF}' >ethturn

while read -r et;
do
m=`echo $et|awk '{print $1}'`
n=`echo $et|awk '{print $2}'`
grep -q "$m" "$w1" && sed -i /$m/d "$w1" &&rm -f /etc/sysconfig/network-scripts/ifcfg-$m
sed -i s/$n/$m/  "$w1" && rm -f /etc/sysconfig/network-scripts/ifcfg-$n
cat >/etc/sysconfig/network-scripts/ifcfg-$m <<AA
DEVICE=$m
HWADDR=`ip address|grep -A2 $n |grep link/eth|awk '{print $2}'`
TYPE=Ethernet
ONBOOT=yes
NM_CONTROLLED=yes
BOOTPROTO=dhcp
AA
done <ethturn
rm -f ethturn
rm $0

