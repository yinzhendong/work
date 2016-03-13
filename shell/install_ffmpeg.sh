#!/bin/bash

packroot=/root

# install labaacplus
yum install -y fftw-devel pkg-config autoconf automake libtool unzip yasm
cd $packroot
wget http://tipok.org.ua/downloads/media/aacplus/libaacplus/libaacplus-2.0.2.tar.gz
tar -xzf libaacplus-2.0.2.tar.gz
cd libaacplus-2.0.2
./autogen.sh --enable-shared --enable-static
make
make install
ldconfig

# install x264
cd $packroot
git clone git://git.videolan.org/x264.git
cd x264/
./configure --enable-static --enable-shared
make
make install

# install lame
cd $packroot
tar zxvf lame-3.99.5.tar.gz
cd lame-3.99.5
./configure
make
make install

# install ffmpeg
git clone git://source.ffmpeg.org/ffmpeg.git
cd ffmpeg
./configure --enable-gpl --enable-libx264 --enable-libmp3lame --enable-nonfree --enable-libaacplus
make
make install
