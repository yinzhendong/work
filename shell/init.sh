#!/bin/sh

rpm -ivh http://apt.sw.be/redhat/el6/en/x86_64/rpmforge/RPMS/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
rpm -ivh http://mirrors.ustc.edu.cn/epel//6/x86_64/epel-release-6-8.noarch.rpm

yum update
yum install -y telnet lrzsz iotop htop iptraf
yum groupinstall -y "Development Tools"
