#!/bin/bash

path=/root

# install x264
cd $path
git clone git://git.videolan.org/x264.git
cd x264/
./configure --enable-static --enable-shared
make
make install
ln -s /usr/local/lib/libmp3lame.so.0.0.0 /usr/lib64/libmp3lame.so.0

# install lame
cd $path
tar zxvf lame-3.99.5.tar.gz
cd lame-3.99.5
./configure
make
make install
ln -s /usr/local/lib/libx264.so.148 /usr/lib64/libx264.so.148

# install HandBrake

yum groupinstall "Development Tools" "Development Libraries" "X Software Development" "GNOME Software Development"
yum install yasm zlib-devel bzip2-devel libogg-devel libtheora-devel libvorbis-devel libsamplerate-devel libxml2-devel fribidi-devel freetype-devel fontconfig-devel libass-devel dbus-glib-devel libgudev1-devel webkitgtk-devel libnotify-devel gstreamer-devel gstreamer-plugins-base-devel
#svn checkout svn://svn.handbrake.fr/HandBrake/trunk hb-trunk
cd $path
wget http://download.handbrake.fr/handbrake/releases/0.10.2/HandBrake-0.10.2.tar.bz2
bzip2 -d HandBrake-0.10.2.tar.bz2
tar xvf HandBrake-0.10.2.tar
cd HandBrake-0.10.2
./configure --launch --disable-gtk
cd build/
make install

ln -s /usr/local/bin/HandBrakeCLI /usr/bin/HandBrakeCLI

