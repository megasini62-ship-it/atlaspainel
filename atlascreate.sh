#!/bin/bash
# atlascreate.sh - Cria um novo usuario SSH
# Uso: ./atlascreate.sh <usuario> <senha> <dias> <limite>

username=$1
password=$2
dias=$3
sshlimiter=$4

if [ -z "$username" ] || [ -z "$password" ] || [ -z "$dias" ] || [ -z "$sshlimiter" ]; then
    echo "Erro: Uso: ./atlascreate.sh <usuario> <senha> <dias> <limite>"
    exit 1
fi

dias=$(($dias+1))
final=$(date "+%Y-%m-%d" -d "+$dias days")
pass=$(perl -e 'print crypt($ARGV[0], "password")' "$password")

# Se o usuario ja existir, remove primeiro
if id "$username" &>/dev/null; then
    pkill -9 -u "$username" 2>/dev/null
    userdel "$username" 2>/dev/null
fi

# Cria o usuario
useradd -e "$final" -M -s /bin/false -p "$pass" "$username"

# Salva a senha
mkdir -p /etc/SSHPlus/senha
echo "$password" > "/etc/SSHPlus/senha/$username"

# Atualiza banco de usuarios local (CORRIGIDO: /etc/xis/ em vez de /sys/xis/)
mkdir -p /etc/xis
if [ -f /etc/xis/usuarios.db ]; then
    grep -v "^${username}[[:space:]]" /etc/xis/usuarios.db > /tmp/usuarios_tmp.db
    mv /tmp/usuarios_tmp.db /etc/xis/usuarios.db
fi
echo "$username $sshlimiter" >> /etc/xis/usuarios.db
