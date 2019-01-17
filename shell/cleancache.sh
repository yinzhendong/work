#!/bin/sh

echo "clean tomcat/work/* ..."
rm -rf tomcat/work/*
echo "done!"

echo "delete tomcat log ..."
rm -rf tomcat/logs/*
echo "done!"
