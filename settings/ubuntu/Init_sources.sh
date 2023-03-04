#!/bin/bash
Codename=$( (lsb_release -a)|awk '{print $2}'|tail -n 1 )
MirrorsName="mirrors.aliyun.com"
echo "\
deb http://$MirrorsName/ubuntu/ $Codename main multiverse restricted universe
deb http://$MirrorsName/ubuntu/ $Codename-backports main multiverse restricted universe
deb http://$MirrorsName/ubuntu/ $Codename-proposed main multiverse restricted universe
deb http://$MirrorsName/ubuntu/ $Codename-security main multiverse restricted universe
deb http://$MirrorsName/ubuntu/ $Codename-updates main multiverse restricted universe
deb-src http://$MirrorsName/ubuntu/ $Codename main multiverse restricted universe
deb-src http://$MirrorsName/ubuntu/ $Codename-backports main multiverse restricted universe
deb-src http://$MirrorsName/ubuntu/ $Codename-proposed main multiverse restricted universe
deb-src http://$MirrorsName/ubuntu/ $Codename-security main multiverse restricted universe
deb-src http://$MirrorsName/ubuntu/ $Codename-updates main multiverse restricted universe 
">sources.list
apt update

