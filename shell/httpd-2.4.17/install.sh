#!/bin/bash

pack_root=/root/httpd-2.4.17

# remove yum httpd apr
yum remove httpd apr -y

# install apr
cd $pack_root
tar zxvf apr-1.5.2.tar.gz
cd apr-1.5.2
./configure
make
make install

# install apr-util
cd $pack_root
tar zxvf apr-util-1.5.4.tar.gz
cd apr-util-1.5.4
./configure --with-apr=/usr/local/apr/
make
make install

# install apr-iconv
cd $pack_root
tar -zxvf apr-iconv-1.2.1.tar.gz
cd apr-iconv-1.2.1
./configure --with-apr=/usr/local/apr/
make
make install

# install pcre
cd $pack_root
tar zxvf pcre-8.36.tar.gz
cd pcre-8.36
./configure
make
make install

# install httpd
cd $pack_root
tar xvf httpd-2.4.17.tar
cd httpd-2.4.17
./configure --prefix=/usr/local/apache2
make
make install
