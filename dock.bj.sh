#!/bin/bash

docker 2013年出现，一种容器虚拟化--linux系统存在形式是一个进程，进程与进程之间是独立分开，相互不能影响，redhat在centos6.5版本后支持docker,使用go语言开发，基于apche2.0协议，开源软件，项目代码在githua上发布。
您的专属加速器地址 https://gsfku2f6.mirror.aliyuncs.com
专属加速器地址 
https://gsfku2f6.mirror.aliyuncs.com
#centos 6 
vi  /etc/sysconfig/docker
最下面增加一行: 
other_args="--registry-mirror=https://olxmv577.mirror.aliyuncs.com"

other_args="--registry-mirror=https://gsfku2f6.mirror.aliyuncs.com"


yum install iproute   #docker中查看ip

docker 通过已有镜像生成文件
docker  save -o centos.tar  centos
#我们还可以用该文件恢复本地镜像：
docker load --input aming-centos.tar  或者
docker load < aming-centos.tar
docker 通过已有容器创建镜像
docker commit -m "add net-tools" -a"newer"  2dfcsds   nettools/centos
docker 通过已有容器生成文件
docker export container_id  > file.tar 
# 导出容器，可以迁移到其他机器上，需要导入
cat file.tar |docker import - test   #这样会生成test的镜像





centos6 上安装
yum install -y epel-release
yum install -y docker-io
centos7 上安装
yum install -y docker
启动docker
 /etc/init.d/docker start
***********************************-------
docker pull  xx
docker search xx
docker images
docker tag xx newname:newtab
docker rmi xx
docker save -o newfile.tar xx
docker load < xx.tar
docker commit -m "change" -a "author" xx  newimagesname
 
docker ps -a
docker rm container_id ;-f 
docker export container_id > filename.tar
cat filename.tar | docker import - newimagesname
docker run --name test  -ti xx /bin/bash
docker create -d -p 23:22 -it xx 
docker start  -it xx
docker exec -it xx /bin/bash
docker attach xx;;;
docker logs container_id
docker run -name ast -dit -v /data/:/data xx bash
# -v 本机目录:容器目录  把本机目录挂载在容器中
docker run -dit --volumes-from ast  centos bash
#以centos 镜像创建并启动容器;并且 依照ast容器 挂载目录样式挂载目录 ;



docker push
docker run -d -p 5000:5000 registry
docker tag xx ip:5000/xx
docker push ip:5000/xx
curl 127.0.0.1:5000/v2/_catalog





************************---------
Docker 镜像管理{
docker pull  centos   
#从docker.com获取centos镜像
docker images 
#查看本地都有哪些镜像
docker tag centos aming123  
#为centos镜像设置标签为aming123，再使用docker images查看会多出来一行，改行的image id和centos的一样
docker search [image-name]   #从docker仓库搜索docker镜像，后面是关键词
docker run -t -i centos  /bin/bash  
#用下载到的镜像开启容器，-i表示让容器的标准输入打开，-t表示分配一个伪终端，要把-i -t 放到镜像名字前面;
#加上-d后，就把容器放到了后台，你可以不用在最后面加/bin/bash, 如果不加-d需要在后面加/bin/bash
当该镜像发生修改后，我们可以把该镜像提交重新生成一个新版本进行在本地。
docker ps  
#查看运行的容器，加上-a选项可以查看没有运行的容器
docker rmi centos  
#用来删除指定镜像， 其中后面的参数可以是tag，如果是tag时，实际上是删除该tag，只要该镜像还有其他tag，就不会删除该镜像。当后面的参数为镜像ID时，则会彻底删除整个镜像，连通所有标签一同删除
}
Docker 基于已有镜像的容器创建镜像{
docker start xx
# 运行docker run后，进入到该容器中，
docker -exec -it xx /bin/bash
# 我们做一些变更，比如安装一些东西，然后针对这个容器进行创建新的镜像
docker commit -m "change somth"  -a "somebody info"  container_id （通过docker ps -a获取id） 新镜像名字
例如： 
 docker commit -m "install httpd" -a "Aming" 2c74d574293f aming/centos
# 这个命令有点像svn的提交，-m 加一些改动信息，-a 指定作者相关信息  2c74d这一串为容器id，再后面为新镜像的名字

}
Docker 基于本地模板导入创建镜像{
#模块获取，可以直接在网上下载一个模块
 http://openvz.org/Download/templates/precreated 
##可惜速度并不快，若我们下载了一个centos的模板 centos-5-x86.tar.gz 那么导入该镜像的命令为：
cat centos-5-x86.tar.gz |docker import - centos-5-x86
#把现有镜像，导出为一个文件：
docker save -o aming-centos.tar aming/centos
#我们还可以用该文件恢复本地镜像：
docker load --input aming-centos.tar  或者
docker load < aming-centos.tar
docker push image_name  //可以把自己的镜像传到dockerhub官方网站上去，但前提是需要先注册一个用户，后续如果有需求再研究吧

}
Docker 容器管理{
docker create  -it  centos   #这样可以创建一个容器，但该容器并没有启动
docker start   container_id   #启动容器后，可以使用 docker ps  查看到，有start 就有stop，和restart
#之前我们使用的docker run 相当于先create再start
docker run -i -t centos  bash 
#这样进入了一个虚拟终端里面，我们可以运行一些命令，使用命令exit或者ctrl d 退出该bash，当退出后这个容器也会停止。
#docker run -d 可以让容器在后台运行,比如：
docker run -d centos  bash -c "while :; do echo "123"; sleep 1; done "
docker run --name web -itd centos bash # --name 给容器自定义名字
docker run --rm -it centos bash -c "sleep 30"
 #--rm    可以让容器退出后直接删除，在这里命令执行完容器就会退出，不能和-d一起使用    
#docker logs 可以获取到容器的运行历史信息，用法如下
docker logs  container_id  
#docker attach 可以进入一个后台运行的容器，比如
docker attach  container_id    
#但是attach命令不算好用，比如我们想要退出终端，就得exit了，这样容器也就退出了，还有一种方法
docker exec -i -t container_id  bash  
#可以临时打开一个虚拟终端，并且exit后，容器依然运行着
docker rm  container_id  
#container_id是ps的时候查看到的，这样就可以把所有container删除，如果是运行的容器，可以加-f强制删除
docker  export  container_id  > file.tar 
# 导出容器，可以迁移到其他机器上，需要导入
cat file.tar |docker import - aming_test   #这样会生成aming_test的镜像


将模板.tar文件、容器.tar文件导入为新镜像 docker import
将容器导出为容器.tar文件 docker export
把现有镜像保存为一个镜像.tar文件 docker save
从一个镜像.tar文件里恢复镜像 docker load
命令	说明
import	openvz模板.tar文件、容器.tar文件 导入为➜ 新镜像
export	容器 导出为➜ 容器.tar文件
save	镜像 保存为➜ 镜像.tar文件
load	镜像.tar文件 恢复为➜ 原来的镜像

docker run --name hc -itd name:tag /bin/bash  ## --name给容器自定义名字
docker run --rm -it name:tag /bin/bash -c "sleep 30"  ## --rm可以让容器退出后直接删除，在这里命令执行完容器就会退出，不能和-d一起使用

容器的迁移：
docker export ID > centos.tar
cat centos.tar | docker import - hc_linux

openvz下载下来所谓的镜像其实是别人导出的容器，所以要用
cat命令去导入容器，而不是load命令导入镜像

。
}
Docker 仓库管理{

经验证，发现你们做实验的时候，版本已经发生了更改。 你们验证用这个地址：
curl http://192.168.1.200:5000/v2/_catalog
注意，这里的ip是你的linux的ip，不要搞错了
 docker pull registry   //下载registry 镜像，registy为docker官方提供的一个镜像，我们可以用它来创建本地的docker私有仓库。
docker run -d -p 5000:5000 registry   //以registry镜像启动容器，监听5000端口
curl 127.0.0.1:5000  //可以访问它
下面我们来把其中一个镜像上传到私有仓库
1. docker tag aming_test  172.7.15.106:5000/centos //标记一下tag，必须要带有私有仓库的ip:port 
2. docker push 172.7.15.106:5000/centos   //此时报错了类似如下
Error response from daemon: invalid registry endpoint https://172.7.15.106:5000/v0/: unable to ping registry endpoint https://172.7.15.106:5000/v0/v2 ping attempt failed with error: Get https://172.7.15.106:5000/v2/: EOF
为了解决这个问题需要在启动docker server时增加启动参数为默认使用http访问。解决该问题的方法为：
vi /etc/init.d/docker  
把 $exec -d $other_args 改为
$exec -d --insecure-registry 172.17.42.1:5000 $other_args
然后重启docker
service docker restart
再启动registry容器
docker start  registry_container_id
curl http://172.17.42.1:5000/v2/_catalog   //可以查看私有仓库里面的所有镜像

}
Docker 数据管理{
docker run -name ast -dit -v /data/:/data xx bash
# -v 本机目录:容器目录  把本机目录挂载在容器中
docker run -dit --volumes-from ast  centos bash
#以centos 镜像创建并启动容器;并且 依照ast容器 挂载目录样式挂载目录 ;

--*-*-*-*-*-定义数据卷容器, 用于共享数据
docker run -itd -v /data/ --name testv centos    bash
# -v /data/  是容器中的目录
docker run --name=testv2 -dit --volumes-from testv  centos bash
#以centos 镜像创建并启动容器;并且 依照ast容器 挂载目录样式挂载目录 ;
备份数据卷容器的数据

docker run --name=testv3 -dit --volumes-from testv -v /data/:/bakup centos tar czvf /bakup/data.tar.gz /data/
#创建并运行容器testv3 并执行tar 命令后关闭容器
#该容器只执行此tar命令并关闭

}
Docker网络管理{
四种网络模式
1.host模式，使用docker run时使用--net=host指定docker使用的网络实际上和宿主机一样，复用所属主机的ip;;复制主机的连接和主机名
2.container模式，使用--net=container:container_id/container_name多个容器使用共同的网络，看到的ip是一样的 即复制container:后容器的网络链接和主机名
3.none模式，使用--net=none指定这种模式下，不会配置任何网络
4.bridge模式，使用--net=bridge指定默认模式，不用指定默认就是这种网络模式。这种模式会为每个容器分配一个独立的Network Namespace。类似于vmware的nat网络模式。同一个宿主机上的所有容器会在同一个网段下，相互之间是可以通信的。


docker run --rm --net=host  -it net /bin/bash 
docker run   -it   net /bin/bash
docker run -it --rm --net=container:efe4 new  /bin/bash


外部网络访问容器：-p 333:80端口映射

docker run -itd -p 555:80 httpd /bin/bash


}
Docker桥接网络{

cd /etc/sysconfig/network-scripts/; cp ifcfg-eth0  ifcfg-br0
vi ifcfg-eth0 //增加BRIDGE=br0，删除IPADDR,NETMASK,GATEWAY,DNS1
vi ifcfg-br0//修改DEVICE为br0,Type为Bridge,把eth0的网络设置设置到这里来
service network restart
#安装pipwork: 
 git clone https://github.com/jpetazzo/pipework;
 cp ~/pipework/pipework /usr/local/bin/
#开启一个容器: 
docker run -itd --net=none --name aming123 centos  /bin/bash
rpm -Uvh https://repos.fedorapeople.org/openstack/EOL/openstack-grizzly/epel-6/iproute-2.6.32-130.el6ost.netns.2.x86_64.rpm #不安会报错Object "netns" is unknown, try "ip help"

docker run -dit --net=none --name=web httpd bash
pipework br0 web 10.1.1.12/24@10.1.1.254
#ip/netmask@gateway

}






 route add default gw xxx.xxx.xxx.xxx br0




dockerfile
wget    http://www.apelearn.com/study_v2/.nginx_conf
curl -O http://www.apelearn.com/study_v2/.nginx_conf 
vim Dockerfile //内容如下
+++++++++++++++++++++

FROM centos
RUN yum install -y pcre-devel gcc make zlib wget zlib-devel openssl-devel net-tools
#install Nginx
ADD http://nginx.org/download/nginx-1.8.0.tar.gz .
RUN tar zxvf nginx-1.8.0.tar.gz
RUN mkdir -p  /usr/local/nginx
RUN cd nginx-1.8.0 && ./configure --prefix=/usr/local/nginx &&make &&make  install
RUN rm -fv /usr/local/nginx/conf/nginx.conf
COPY  .nginx_conf /usr/local/nginx/conf/nginx.conf
EXPOSE 80
ENTRYPOINT /usr/local/nginx/sbin/nginx -c /usr/local/nginx/conf/nginx.conf

***************************** 
docker build -t centos_nginx .
docker images 
vi centos_nginx


------------************************

vim Dockerfile //内容如下
############################################################
# Dockerfile to build Nginx Installed Containers Based on CentOS Set the base image to CentOS FROM centos 
# File Author / Maintainer
MAINTAINER aming aming@aminglinux.com
# Install necessary tools
RUN yum install -y pcre-devel wget net-tools gcc
RUN yum install -y zlib zlib-devel make
RUN yum install -y openssl-devel

# Install Nginx
ADD http://nginx.org/download/nginx-1.8.0.tar.gz .
RUN tar zxvf nginx-1.8.0.tar.gz
RUN mkdir -p /usr/local/nginx
RUN cd nginx-1.8.0 && ./configure --prefix=/usr/local/nginx && make && make install
RUN rm -fv /usr/local/nginx/conf/nginx.conf
COPY .nginx_conf /usr/local/nginx/conf/nginx.conf
# Expose ports
EXPOSE 80
# Set the default command to execute
# when creating a new container
ENTRYPOINT /usr/local/nginx/sbin/nginx -c /usr/local/nginx/conf/nginx.conf
创建镜像：
docker build -t centos_nginx  .
docker  images 可以看到我们新建的镜像










