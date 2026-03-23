pass=$(perl -e 'print crypt($ARGV[0], "password")' $2)
final=$(date "+%Y-%m-%d" -d "+2 days")
useradd -e $final -M -s /bin/false -p $pass $1
username="$1"
password="$2"
dias="$3"
sshlimiter="$4"
echo "$password" > /etc/SSHPlus/senha/$username
mkdir -p /sys/xis
echo "$username $sshlimiter" >> /sys/xis/usuarios.db
echo "#!/bin/bash
pkill -f "$username"
userdel --force $username
grep -v ^$username[[:space:]] /sys/xis/usuarios.db > /tmp/ph ; cat /tmp/ph > /sys/xis/usuarios.db
rm /etc/SSHPlus/senha/$username > /dev/null 2>&1
rm -rf /etc/SSHPlus/userteste/$username.sh
exit" > /etc/SSHPlus/userteste/$username.sh
chmod +x /etc/SSHPlus/userteste/$username.sh
at -f /etc/SSHPlus/userteste/$username.sh now + $dias min > /dev/null 2>&1
