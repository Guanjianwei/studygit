#!/bin/bash

install_mysqld() {
	echo "Install mysql- 5.1.72..."
	ar=`arch`
	cd  /usr/local/src
	#wget http://downloads.mysql.com/archives/get/file/mysql-5.1.72-linux-x86_64-glibc23.tar.gz
	wget http://mirrors.sohu.com/mysql/MySQL-5.1/mysql-5.1.72-linux-$ar-glibc23.tar.gz 
	[ -d /usr/local/mysql ] && /bin/mv /usr/local/mysql /usr/local/mysql_`date +%s`
	tar -xzf mysql-5.1.72-linux-$ar-glibc23.tar.gz  -C /usr/local/   &&  ln -s /usr/local/mysql-5.1.72-linux-$ar-glibc23  /usr/local/mysql
	useradd -M -s /sbin/nologin mysql 2>&1
	[ -d /data/mysql ] && /bin/mv /data/mysql /data/mysql_`date +%s`
	mkdir -p /data/mysql &&chown mysql:mysql  /data/mysql
	 cd /usr/local/mysql 
	 ./scripts/mysql_install_db --user=mysql --datadir=/data/mysql
	 /bin/cp support-files/my-large.cnf /etc/my.cnf 
	 /bin/cp support-files/mysql.server  /etc/init.d/mysqld
	 chmod 755 /etc/init.d/mysqld
	 #echo 'alias mysql=/usr/local/mysql/bin/mysql' >>/root/.bashrc

	sed -i 's#^datadir=#datadir=/data/mysql#' /etc/init.d/mysqld
	#vim /etc/init.d/mysqld Ìí¼Ódatadir=/data/mysql
	 chkconfig --add mysqld
	 chkconfig mysqld on
	 service mysqld start
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

check_service mysqld

echo "mysql is installed."

 