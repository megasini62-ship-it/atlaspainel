#!/bin/bash
username=$1
password=$2
dias=$3
sshlimiter=$4
dias=$(($dias+1))
final=$(date "+%Y-%m-%d" -d "+$dias days")
gui=$(date "+%d/%m/%Y" -d "+$dias days")
pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
useradd -e $final -M -s /bin/false -p $pass $username
echo "$password" > /etc/SSHPlus/senha/$username
mkdir -p /sys/xis
echo "$username $sshlimiter" >> /sys/xis/usuarios.db
