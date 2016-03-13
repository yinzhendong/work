#!/bin/bash

yum install -y tigervnc-server

echo "export DISPLAY=:1.0" >> /etc/profile
source /etc/profile
chkconfig vncserver on

echo "VNCSERVERS=\"1:root\"" >> /etc/sysconfig/vncservers
echo "VNCSERVERARGS[1]=\"-geometry 800x600 -nolisten tcp -localhost\"" >> /etc/sysconfig/vncservers

vncserver

