#!/bin/bash

#cleanup,
# by GUI ---2016-09-11
LOG_DIR=/var/log
ROOT_UID=0  #$UID为0时，用户具有root权限
LINES=50	#默认保存的行数
E_XCD=66	#不能修改的目录
E_NOTROOT=67	#非root用户将以error退出

#必须用root用户来执行
if [ "$UID" -ne "$ROOT_UID" ]
then
echo "Must be root to run this script."
exit $E_NOTROOT
fi

##get the archive of the system,i686 or x86_64.
check_ok(){
if [ $? != 0 ]
then
    echo "Error, Check the error log."
    exit 1
fi
}
setenforce 0
iptables -F


install_mysqld(){
	echo "Install mysql- 5.1.72..."
	ar=`arch`
	cd  /usr/local/src
	#wget http://downloads.mysql.com/archives/get/file/mysql-5.1.72-linux-x86_64-glibc23.tar.gz
	[ -f mysql-5.1.73-linux-$ar-glibc23.tar.gz  ] ||wget http://mirrors.sohu.com/mysql/MySQL-5.1/mysql-5.1.73-linux-$ar-glibc23.tar.gz 
	[ -d /usr/local/mysql ] && /bin/mv /usr/local/mysql /usr/local/mysql_`date +%s`
	tar -xzf mysql-5.1.73-linux-$ar-glibc23.tar.gz  -C /usr/local/   &&  ln -s /usr/local/mysql-5.1.73-linux-$ar-glibc23  /usr/local/mysql
	check_ok
	useradd -M -s /sbin/nologin mysql 2>&1
	[ -d /data/mysql ] && /bin/mv /data/mysql /data/mysql_`date +%s`
	mkdir -p /data/mysql &&chown mysql:mysql  /data/mysql
	 cd /usr/local/mysql 
	 ./scripts/mysql_install_db --user=mysql --datadir=/data/mysql
	 check_ok
	 /bin/cp support-files/my-large.cnf /etc/my.cnf 
	 /bin/cp support-files/mysql.server  /etc/init.d/mysqld
	 chmod 755 /etc/init.d/mysqld
	 #echo 'alias mysql=/usr/local/mysql/bin/mysql' >>/root/.bashrc

	sed -i 's#^datadir=#datadir=/data/mysql#' /etc/init.d/mysqld
	#vim /etc/init.d/mysqld 添加datadir=/data/mysql
	 chkconfig --add mysqld
	 chkconfig mysqld on
	 service mysqld start
	 check_ok
}
install_httpd() {
echo "Install apache version 2.2."

yum install -y gcc zlib-devel 
cd /usr/local/src
vhttp=httpd-2.2.32
[ -f $vhttp.tar.bz2  ] || wget  http://mirrors.aliyun.com/apache/httpd/vhttp.tar.bz2
tar -xjf $vhttp.tar.bz2 && cd $vhttp
#check_ok
./configure \
--prefix=/usr/local/httpd \
--with-included-apr \
--enable-so \
--enable-deflate=shared \
--enable-expires=shared \
--enable-rewrite=shared \
--with-pcre
check_ok
make && make install
check_ok
/bin/cp /usr/local/httpd/bin/apachectl  /etc/init.d/httpd &&chmod 755 /etc/init.d/httpd
check_ok
sed -i '/^#!\/bin\/sh$/a\# chkconfig: 2345 85 35 \n# description: Apache ' /etc/init.d/httpd
chkconfig  httpd --add &&chkconfig httpd  on
sed -i '/^#ServerName www.example.com:80$/a\ServerName localhost:80' /usr/local/httpd/conf/httpd.conf
service httpd start
check_ok
}
install_php() {
echo "it is installing php-5.6"

yum install -y  perl perl-devel libxml2-devel  openssl-devel  bzip2-devel  libjpeg-devel  libpng-devel   freetype-devel  libmcrypt-devel
cd  /usr/local/src
[ -f php-5.6.29.tar.bz2 ] || wget http://mirrors.sohu.com/php/php-5.6.29.tar.bz2
#wget http://cn2.php.net/distributions/php-5.6.29.tar.bz2
tar -xjf php-5.6.29.tar.bz2  &&cd php-5.6.29
./configure   --prefix=/usr/local/php5.6.29  --with-apxs2=/usr/local/httpd/bin/apxs   --with-config-file-path=/usr/local/php/etc   --with-mysql=/usr/local/mysql   --with-libxml-dir   --with-gd   --with-jpeg-dir   --with-png-dir   --with-freetype-dir   --with-iconv-dir   --with-zlib-dir   --with-bz2   --with-openssl   --with-mcrypt   --enable-soap   --enable-gd-native-ttf   --enable-mbstring   --enable-sockets   --enable-exif   --disable-ipv6

check_ok
make &&make install
check_ok
/bin/cp php.ini-production  /usr/local/php5.6.29/etc/php.ini
check_ok
ln -s /usr/local/php5.6.29 /usr/local/php

# 在httpd配置文件中添加支持
sed -i '/AddType application\/x-gzip .gz .tgz/a\AddType application\/x-httpd-php .php' /usr/local/httpd/conf/httpd.conf
sed -i '/index.html/c\DirectoryIndex index.html index.htm index.php' /usr/local/httpd/conf/httpd.conf
cat > /usr/local/httpd/htdocs/index.php <<EOF
<?php
	phpinfo();
EOF

sed -i '/;date.timezone =$/a\date.timezone = "Asia\/Chongqing"'  /usr/local/php/etc/php.ini
check_ok
/usr/local/httpd/bin/apachectl restart

}
##function of check service is running or not, example nginx, httpd, php-fpm.
check_service() {
if [ "$1" == "phpfpm" ]
then
    s="php-fpm"
else
    s=$1
fi
n=`ps aux |grep "$s"|wc -l`
if [ $n -gt 1 ]
then
    echo "$1 service is already started."
else
    if [ -f /etc/init.d/$1 ]
    then
        /etc/init.d/$1 start
        check_ok
    else
        install_$1
    fi
fi
}
##function of install lamp
install_LAMP(){
	check_service mysqld
	check_service httpd
	install_php
	echo "LAMP done，Please use 'http://your ip/index.php' to access."

}
cdir=`pwd`
install_LAMP 2>&1|tee  $cdir/install_LAMP.log

