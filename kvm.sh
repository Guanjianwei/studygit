笔记本桥接网络设置 bridge-utils
brtcl show
brctl addbr br0
brctl addif  wlan0
brctl stp br0 stop
dhclient br0


**********************************************************
常用操作 {
a. 开启子机
virsh start centos6.6_1
也可以在开启的同时连上控制台
virsh start centos6.6_1 --console
b. 关闭子机
virsh shutdown centos6.6_1 （这个需要借助子机上的acpid服务）
另外一种方法是 
virsh destroy centos6.6_1 
c. 让子机随宿主机开机自动启动
virsh autostart centos6.6_1
解除自动启动
virsh autostart --disable centos6.6_1 
d. 列出子机
virsh list  //只能列出启动的子机
virsh list --all  //可以把所有子机都列出来
e. 删除子机
virsh destroy clone1
virsh undefine clone1
rm -f /data/clone1.img
f. 挂起子机
virsh suspend centos6.6_1
h. 恢复子机
virsh resume centos6.6_1		 
 }


虚拟机迁移{
该方式要确保虚拟机是关机状态。
virsh shutdown test02
virsh dumpxml test02 > /etc/libvirt/qemu/test03.xml  # #如果是远程机器，需要把该配置文件拷贝到远程机器上
virsh domblklist test02  //查看test02子机的磁盘所在目录
rsync -av /data/add1.qcow2 /data/test03.qcow2   #如果是迁移到远程，则需要把该磁盘文件拷贝到远程机器上
vi /etc/libvirt/qemu/test03.xm  //因为是迁移到本机，配置文件用的是test02子机的配置，不改会有冲突，所以需要修改该文件，如果是远程机器不用修改
#修改domname:
test03
#修改uuid（随便更改一下数字，位数不要变）
77bb10bd-3ad8-8899-958d-756063002969
#修改磁盘路径：
<disk type='file' device='disk'>
      <driver name='qemu' type='raw' cache='none'/>
      <source file='/data/test03.qcow2'/>
      <target dev='vda' bus='virtio'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x05' function='0x0'/>
    </disk>

virsh list --all   #会发现新迁移的test03子机
virsh  define /test.xml

}
 不重启虚拟机在线增加网卡{
virsh domiflist test02  #查看test02子机的网卡列表
virsh attach-interface test02 --type bridge --source br0   #命令行增加一块网卡
virsh dumpxml test02 > /etc/libvirsh/qemu/test02.xml   #命令行增加的网卡只保存在内存中，重启就失效，所以需要保存到配置文件中，其中/etc/libvirsh/qemu/test02.xml 为test02子机的配置文件
virsh console test02 #进入虚拟机后，执行
ifconfig -a  #发现多了一个网卡  eth1
}
调整cpu和内存查看子机配置：
{
virsh dominfo test02
virsh edit  test02
修改：

重启虚拟机：
virsh destroy test02
virsh start test02
}
 克隆虚拟机{
virt-clone --original centos6.6_1 --name template --file /data/clone1.img  
# 如果子机centos6.6_1还未关机，则需要先关机，否则会报错：
# ERROR    必须暂停或者关闭有要克隆设备的域。
# 关闭子机的方法是：
virsh shutdown centos6.6_1

# 说明： 默认，我们没有办法在宿主机直接shutdown自己，我们需要借助于子机上的acpid服务才可以，这个服务说白了就是让宿主机可以去调用子机的电源关闭的接口。所以，子机上需要安装并启动acpid服务。
# 先登录子机：
virsh console centos6.6_1
# 登录后，安装acpid服务:
yum install -y acpid 
启动：
/etc/init.d/acpid start
按ctrl ] 退出来
此时再执行 virsh shutdown centos6.6_1 就可以啦。

克隆完后，virsh list all 就会发现clone1 这个子机，通过命令 
virsh start clone1 可以开启该子机。


}
 virsh 
 
 快照管理{
 a. 创建快照
virsh snapshot-create centos6.6_1
# 会报错：
# unsupported configuration: internal snapshot for disk vda unsupported for storage type raw
# 这是因为raw格式的镜像不能做快照，所以需要先转换一下格式
# b. 磁盘镜像转换格式
# 先查看当前子机磁盘镜像格式
qemu-img info /data/centos6.6_1.img  
结果是：
image: /data/centos6.6_1.img
file format: raw
virtual size: 30G (32212254720 bytes)
disk size: 1.6G

# 把raw格式转换为qcow格式（其实是复制了一份）：
qemu-img convert -f raw -O qcow2 /data/centos6.6_1.img /data/centos6.6_1.qcow2

qemu-img info /data/centos6.6_1.qcow2   //再次查看格式，结果如下
image: /data/centos6.6_1.qcow2
file format: qcow2
virtual size: 30G (32212254720 bytes)
disk size: 1.1G
cluster_size: 65536
#现在我们还需要编辑子机配置文件，让它使用新格式的虚拟磁盘镜像文件
virsh edit centos6.6_1  #这样就进入了该子机的配置文件（/etc/libvirt/qemu/centos6.6_1.xml），跟用vim编辑这个文件一样的用法需要修改的地方是：
      <driver name='qemu' type='raw' cache='none'/>
      <source file='/data/centos6.6_1.img'/>

改为：
      <driver name='qemu' type='qcow2' cache='none'/>
      <source file='/data/centos6.6_1.qcow2'/>


c. 继续创建快照
virsh snapshot-create centos6.6_1  #这次成功了，提示如下
Domain snapshot 1437248443 created
#列出快照：
virsh snapshot-list centos6.6_1
#查看当前子机的快照版本：
virsh snapshot-current centos6.6_1
#centos6.6_1子机的快照文件在  /var/lib/libvirt/qemu/snapshot/centos6.6_1/  目录下
d.  恢复快照
#首先需要关闭子机
virsh destroy centos6.6_1
#确认子机是否关闭
virsh domstate centos6.6_1
关闭

vish snapshot-list centos6.6_1  //结果是
名称               Creation Time             状态
------------------------------------------------------------
1437248443           2015-07-19 03:40:43 +0800 shutoff
1437248847           2015-07-19 03:47:27 +0800 running


virsh snapshot-revert centos6.6_1  1437248443

e. 删除快照
virsh snapshot-delete centos6.6_1  1437248847
 
 } 
 磁盘扩容{
 a. 对于raw格式的虚拟磁盘扩容

qemu-img info /data/kvm/test03.img //本身只有9G
image: /data/kvm/test03.img
file format: raw
virtual size: 9.0G (9663676416 bytes)
disk size: 1.1G

qemu-img resize /data/kvm/test03.img +2G

qemu-img info /data/kvm/test03.img //现在增加了2G
image: /data/kvm/test03.img
file format: raw
virtual size: 11G (11811160064 bytes)
disk size: 1.1G

virsh destroy test03  //关闭test03虚拟机
virsh start test03  //开启test03虚拟机
virsh console test03  //进入虚拟机

fdisk -l   查看已经磁盘分区已经增加
[root@localhost ~]# fdisk -l
但是磁盘挂载的空间并没有增加
[root@localhost ~]# df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/mapper/VolGroup-lv_root
                      6.5G  579M  5.6G  10% /
tmpfs                 250M     0  250M   0% /dev/shm
/dev/vda1             477M   26M  427M   6% /boot


因为新增加的空间还没有划分使用。所以要继续分区：
[root@localhost ~]# fdisk /dev/vda
然后再把这个/dev/vda3 加入到lvm里面去：

ls  /dev/vda3 如果没有这个分区，需要重启一下。

[root@localhost ~]# pvcreate /dev/vda3
pvs
PV         VG       Fmt  Attr PSize PFree
  /dev/vda2 <font color="#ff0000"> VolGroup</font> lvm2 a--  7.51g    0
  /dev/vda3           lvm2 ---  3.00g 3.00g

[root@localhost ~]# vgextend VolGroup /dev/vda3
Volume group "VolGroup" successfully extended

[root@localhost ~]# vgs
VG       #PV #LV #SN Attr   VSize  <font color="#ff0000">VFree</font>
  VolGroup   2   2   0 wz--n- 10.50g <font color="#ff0000">3.00g</font>

[root@localhost ~]# lvs
LV      VG       Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  lv_root VolGroup -wi-ao----   6.71g
  lv_swap VolGroup -wi-ao---- 816.00m

[root@localhost ~]# lvextend -l +100%FREE /dev/VolGroup/lv_root
Size of logical volume VolGroup/lv_root changed from 6.71 GiB (1718 extents) to 9.71 GiB (2485 extents).
  Logical volume lv_root successfully resized

[root@localhost ~]# df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/mapper/VolGroup-lv_root
                      6.5G  618M  5.6G  10% /
tmpfs                 250M     0  250M   0% /dev/shm
/dev/vda1             477M   26M  427M   6% /boot

[root@localhost ~]# resize2fs /dev/VolGroup/lv_root
resize2fs 1.41.12 (17-May-2010)
Filesystem at /dev/VolGroup/lv_root is mounted on /; on-line resizing required
old desc_blocks = 1, new_desc_blocks = 1
Performing an on-line resize of /dev/VolGroup/lv_root to 2544640 (4k) blocks.
The filesystem on /dev/VolGroup/lv_root is now 2544640 blocks long.

[root@localhost ~]# df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/mapper/VolGroup-lv_root
                     <font color="#ff0000"> 9.5G  </font>618M  8.4G   7% /
tmpfs                 250M     0  250M   0% /dev/shm
/dev/vda1             477M   26M  427M   6% /boot

另外，如果是增加磁盘，思路是： 
创建磁盘： qemu-img create -f raw  /data/kvm/test03_2.img 5G
关闭虚拟机： virsh destroy test03
编辑配置文件： virsh edit test03  增加如下：
<disk type='file' device='disk'>     
  <driver name='qemu' type='raw' cache='none'/>      
  <source file='/data/kvm/test03_2.img'/>      
  <target dev='vdb' bus='virtio'/>      
</disk>

开启虚拟机：virsh start test03
进入虚拟机：virsh console test03
分区： fdisk /dev/vdb
格式化 （略）
挂载 （略）
当然也可以按照上面的思路把 /dev/vdb1 加入到 lvm里面去


b. qcow2格式
步骤基本上和raw一样。如果提示 This image format does not support resize, 检查一下你qemu-img create的时候，是否有加  preallocation=metadata 选项，如果有，就不能resize了。
 
 
 }
 

***********************************

[root@taokey libvirt]# qemu-img create -f qcow2 -o preallocation=metadata kvm_mode.img 10G        

**************************************************************************************
解决办法：利用vnc或宿主机的桌面进入客户机vm01中添加参数

1、添加ttyS0的安全许可，允许root登录:

# echo "ttyS0" >> /etc/securetty

2、在/etc/grub.conf文件中为内核添加参数:

console=ttyS0

这步要注意：

console=ttyS0一定要放在kernel这行中(大约在第16行)，不能单独一行，即console=ttyS0是kernel的一个参数，不是单独的
3、在/etc/inittab中添加agetty:

S0:12345:respawn:/sbin/agetty ttyS0 115200

4、重启客户机:

****************************************
安装{
创建qcow2格式的磁盘；它支持快照功能
qemu-img create -f qcow2 /win/app/kvmdisk/os2.qcow2 30G
root 用户
******************************文本安装
virt-install \
--name  os1 \
--ram 512 \
--disk path=/win/app/kvmdisk/os1.qcow2,size=30,format=qcow2 \
--vcpus 1 \
--os-type linux \
--os-variant rhel6 \
--network bridge=br6 \
--graphics none \
--console pty,target_type=serial \
--location /win/app/kvmdisk/CentOS-6.5-x86_64-bin-DVD1.iso \
--extra-args 'console=ttyS0,115200n8 serial'

*************vnc连接
virt-install \
--name  os4 \
--ram 512 \
--cdrom=/win/app/kvmdisk/CentOS-6.5-x86_64-bin-DVD1.iso  \
--disk path=/win/app/kvmdisk/os2.qcow2,size=30,format=qcow2 \
--vcpus 1  \
--os-type linux \
--os-variant rhel6 \
--network network=default  \
--graphics vnc,listen=0.0.0.0 --check path_in_use=off --noautoconsole


#--location 'http://mirrors.163.com/centos/6.7/os/i386/' 
--disk path=/data/centos-6.4.qcow2,size=10,format=qcow2\
--cdrom=/data/CentOS-6.4-x86_64-netinstall.iso
--graphics vnc,listen=0.0.0.0 --noautoconsole
使用 qemu-img 和 qemu-kvm 命令行方式安装{

（1）创建一个空的qcow2格式的镜像文件

qemu-img create -f qcow2 windows-master.qcow2 10G

（2）启动一个虚机，将系统安装盘挂到 cdrom，安装操作系统

qemu-kvm  -hda  windows-master.qcow2  -m 512 -boot d  -cdrom 
/home/user/isos/en_winxp_pro_with_sp2.iso

（3）现在你就拥有了一个带操作系统的镜像文件。你可以以它为模板创建新的镜像文件。使用模板的好处是，它会被设置为只读所以可以免于破坏。

qemu-img create -b windows-master.qcow2 -f  qcow2   windows-clone.qcow2

（4）你可以在新的镜像文件上启动虚机了

qemu-kvm  -hda  windows-clone.qcow2  -m 400
}


*************************************************************
4. 创建虚拟机
mkdir /data/   //创建一个存储虚拟机虚拟磁盘的目录，该目录所在分区必须足够大

virt-install \
--name  aming1 \
--ram 512 \
--disk path=/data/aming1.img,size=30 \
--vcpus 1 \
--os-type linux \
--os-variant rhel6 \
--network bridge=br0 \
--graphics none \
--console pty,target_type=serial \
--location 'http://mirrors.163.com/centos/6.7/os/i386/' \
--extra-args 'console=ttyS0,115200n8 serial'


说明：
--name  指定虚拟机的名字
--ram 指定内存分配多少
--disk path 指定虚拟磁盘放到哪里，size=30 指定磁盘大小为30G,这样磁盘文件格式为raw，raw格式不能做快照，后面有说明，需要转换为qcow2格式，如果要使用qcow2格式的虚拟磁盘，需要事先创建qcow2格式的虚拟磁盘。 参考  http://www.361way.com/kvm-qcow2-preallocation-metadata/3354.html   示例:qemu-img create -f qcow2 -o preallocation=metadata  /data/test02.img 7G;  --disk path=/data/test02.img,format=qcow2,size=7,bus=virtio
--vcpus 指定分配cpu几个
--os-type 指定系统类型为linux
--os-variant 指定系统版本
--network  指定网络类型
--graphics 指定安装通过哪种类型，可以是vnc，也可以没有图形，在这里我们没有使用图形直接使用文本方式
--console 指定控制台类型
--location 指定安装介质地址，可以是网络地址，也可以是本地的一个绝对路径，（--location '/mnt/', 其中/mnt/下就是我们挂载的光盘镜像mount /dev/cdrom /mnt)如果是绝对路径，那么后面还需要指定一个安装介质，比如NFS，假如虚拟机设置ip后，不能连外网，那么就会提示让我们选择安装途径：
--location '/win/data/std/sourcecode/centos/CentOS-6.8-x86_64-bin-DVD1.iso'
--location 'http://mirrors.aliyun.com/centos/7/os/x86_64/' \



[root@c6 init.d]# virsh undefine 6c
错误：Refusing to undefine while domain managed save image exists
virsh undefine 6c --managed-save
域 6c 已经被取消定义




*******************
virt-install \
--name  6c \
--ram 512 \
--disk path=/win/app/kvmdisk/cent/6c.img,size=30 \
--vcpus 1 \
--os-type linux \
--os-variant rhel6 \
--network bridge=br0 \
--graphics none \
--console pty,target_type=serial \
--location 'http://mirrors.aliyun.com/centos/6/os/i386/' \
--extra-args 'console=ttyS0,115200n8 serial'
