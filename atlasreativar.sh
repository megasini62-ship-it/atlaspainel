#!/bin/bash
# atlasreativar.sh - Reativa (desbloqueia) um usuário SSH suspenso
# Uso: ./atlasreativar.sh <usuario> <senha> <dias> <limite>
# Se o usuario existir, desbloqueia e atualiza a validade
# Se nao existir, recria a conta

username=$1
password=$2
dias=$3
sshlimiter=$4

if [ -z "$username" ] || [ -z "$password" ] || [ -z "$dias" ] || [ -z "$sshlimiter" ]; then
    echo "Erro: Uso: ./atlasreativar.sh <usuario> <senha> <dias> <limite>"
    exit 1
fi

dias=$(($dias+1))
final=$(date "+%Y-%m-%d" -d "+$dias days")
pass=$(perl -e 'print crypt($ARGV[0], "password")' "$password")

if id "$username" &>/dev/null; then
    # Usuario existe - desbloqueia e atualiza validade
    usermod -U "$username" 2>/dev/null
    chage -E "$final" "$username" 2>/dev/null
    # Atualiza a senha
    echo "$username:$password" | chpasswd 2>/dev/null
    echo "1"
else
    # Usuario nao existe - recria
    useradd -e "$final" -M -s /bin/false -p "$pass" "$username" 2>/dev/null
    echo "2"
fi

# Atualiza arquivos auxiliares
mkdir -p /etc/SSHPlus/senha
echo "$password" > "/etc/SSHPlus/senha/$username"

# Atualiza banco de usuarios local
mkdir -p /etc/xis
if [ -f /etc/xis/usuarios.db ]; then
    grep -v "^${username}[[:space:]]" /etc/xis/usuarios.db > /tmp/usuarios_tmp.db
    mv /tmp/usuarios_tmp.db /etc/xis/usuarios.db
fi
echo "$username $sshlimiter" >> /etc/xis/usuarios.db

exit 0
