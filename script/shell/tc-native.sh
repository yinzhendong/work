#!/bin/bash
# install tomcat-native
# install requirements
yum install -y apr-devel openssl-devel java-1.7.0-openjdk-devel

# install tc-native
tar zxvf tomcat-native-1.1.33-src.tar.gz 
cd tomcat-native-1.1.33-src/jni/native/
./configure --with-apr=/usr/bin/apr-1-config --with-java-home=/usr/lib/jvm/java-1.7.0 --with-ssl=yes --prefix=/usr/local/apache-tomcat-7.0.61
make && make install

# extra tomcat
tar zxvf apache-tomcat-7.0.61.tar.gz 
mv apache-tomcat-7.0.61 ../
ln -s apache-tomcat-7.0.61/ tomcat

# update environment file

