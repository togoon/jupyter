#!/bin/bash

FILE_PATH='/home/at/test/log/'
FILE_NAME='t2.log'

LAST_MODIFY_TIMESTAMP=`stat -c %Y  $FILE_PATH$FILE_NAME`
formart_date=`date '+%Y-%m-%d %H:%M:%S' -d @$LAST_MODIFY_TIMESTAMP`
echo $formart_date : $LAST_MODIFY_TIMESTAMP
