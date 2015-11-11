#!/bin/bash

yum install -y java-1.7.0-openjdk-devel
echo "JAVA_HOME=/usr/lib/jvm/java-1.7.0-openjdk.x86_64" >> /etc/profile
echo "PATH=$PATH:$JAVA_HOME/bin" >> /etc/profile
echo "export JAVA_HOME PATH" >> /etc/profile
source /etc/profile

