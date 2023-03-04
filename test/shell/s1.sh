#!/bin/bash

[ !  -f /root/wyb/bo/cat.log  ]  && cat *.html > /root/wyb/bo/cat.log
cat1 *.html >tmp.log

cmp tmp.log /root/wyb/bo/cat.log

[ `$?` -eq 0 ] && echo yes || echo no

if