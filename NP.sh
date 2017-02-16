
#!/bin/bash




install_nginx()  {
echo "it is installing nginx1.8"
yum install -y pcre-devel
cd /usr/local/src
[ -f nginx-1.8.1 ] || wget http://nginx.org/download/nginx-1.8.1.tar.gz
tar -zxvf nginx-1.8.1.tar.gz &&cd nginx-1.8.1
./configure \
--prefix=/usr/local/nginx1.8.1 \
--with-http_realip_module  \
--with-http_sub_module \
--with-http_gzip_static_module \
--with-http_stub_status_module \
--with-pcre
make&&make install
ln -s /usr/local/nginx1.8.1/ /usr/local/nginx


}

install_php() {
echo "it is installing php-5.4"

yum install -y  perl perl-devel libxml2-devel  openssl-devel  bzip2-devel  libjpeg-devel  libpng-devel   freetype-devel  libmcrypt-devel libcurl-devel libtool-ltdl-devel
cd  /usr/local/src
#[ -f php-5.6.29.tar.bz2 ] || wget http://mirrors.sohu.com/php/php-5.6.29.tar.bz2
#wget http://cn2.php.net/distributions/php-5.6.29.tar.bz2
#tar -xjf php-5.6.29.tar.bz2  &&cd php-5.6.29
[ -f php-5.4.45.tar.bz2 ] || wget 'http://cn2.php.net/get/php-5.4.45.tar.bz2/from/this/mirror' -O php-5.4.45.tar.bz2
tar jxf php-5.4.45.tar.bz2 && cd php-5.4.45
./configure --prefix=/usr/local/php-5.4.45   --with-config-file-path=/usr/local/php-5.4.45/etc  --enable-fpm   --with-fpm-user=php-fpm  --with-fpm-group=php-fpm   --with-mysql=/usr/local/mysql  --with-mysql-sock=/tmp/mysql.sock  --with-libxml-dir  --with-gd   --with-jpeg-dir   --with-png-dir   --with-freetype-dir  --with-iconv-dir   --with-zlib-dir   --with-mcrypt   --enable-soap   --enable-gd-native-ttf   --enable-ftp  --enable-mbstring  --enable-exif    --disable-ipv6     --with-curl  --with-pear --with-openssl
make&&make install
[ -f /usr/local/php-5.4.45/etc/php.ini ] || /bin/cp php.ini-production  /usr/local/php-5.4.45/etc/php.ini
/bin/cp sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm
chmod 755 /etc/init.d/php-fpm
useradd -s /sbin/nologin php-fpm
ln -s /usr/local/php-5.4.45/ /usr/local/php
cat >/usr/local/php/etc/php-fpm.conf <<EOF
[global] 
pid = /usr/local/php/var/run/php-fpm.pid
error_log = /usr/local/php/var/log/php-fpm.log 
[www] 
listen = /tmp/php-fcgi.sock 
user = php-fpm 
group = php-fpm
listen.owner = nobody
listen.group = nobody
pm = dynamic 
pm.max_children = 50 
pm.start_servers = 20 
pm.min_spare_servers = 5 
pm.max_spare_servers = 35 
pm.max_requests = 500 
rlimit_files = 1024 

EOF

}

install_NP() {
install_nginx
install_php
}


install_NP 2>&1 |tee /tmp/NP.log

