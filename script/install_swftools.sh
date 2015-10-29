#!/bin/bash

yum install zlib zlib-devel libjpeg libjpeg-devel giflib giflib-devel freetype freetype-devel

wget http://www.swftools.org/swftools-2013-04-09-1007.tar.gz
tar zxvf swftools-2013-04-09-1007.tar.gz
cd swftools-2013-04-09-1007
./configure
make
make install

