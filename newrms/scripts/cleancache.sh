#!/bin/sh

echo "clean tomcat/work/* ..."
rm -rf /home/boful/tomcat/work/*
echo "done!"

echo "delete tomcat log ..."
rm -rf /home/boful/tomcat/logs/*
echo "done!"
