#!/bin/sh

kill -9 `jps |grep Bootstrap |awk '{print $1}'`
