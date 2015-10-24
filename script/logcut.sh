#!/bin/bash
# cut log

yesterday=`date -d yesterday +%Y%m%d`

srclog="/usr/local/apache2/logs/access_log"

dstlog="/usr/local/apache2/logs/$yesterday.access.log"

mv $srclog $dstlog

pkill -1 httpd