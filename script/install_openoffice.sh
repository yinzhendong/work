#!/bin/bash

tar zxvf Apache_OpenOffice_4.1.2_Linux_x86-64_install-rpm_zh-CN.tar.gz
tar zxvf Apache_OpenOffice_4.1.2_Linux_x86-64_langpack-rpm_zh-CN.tar.gz

cd zh-CN/RPMS
rpm -ivh *.rpm

# backup libreoffice /usr/bin/soffice to /usr/bin/soffice.libreoffice
mv /usr/bin/soffice /usr/bin/soffice.libreoffice

# make openoffice /usr/bin/soffice
ln -s /opt/openoffice4/program/soffice /usr/bin/soffice
