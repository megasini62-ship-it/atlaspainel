#!/bin/bash
# atlasremove.sh - Remove (exclui) um usuário SSH do servidor
# Uso: ./atlasremove.sh <usuario>

USR_EX=$1

if [ -z "${USR_EX}" ]; then
    echo "Erro: Voce deve especificar um usuario."
    exit 1
fi

# Verifica se o usuario existe no sistema
if id "$USR_EX" &>/dev/null; then
    # Mata todos os processos do usuario (se houver)
    pkill -9 -u "$USR_EX" 2>/dev/null
    sleep 0.5

    # Remove o usuario do sistema
    userdel "$USR_EX" 2>/dev/null

    # Limpa arquivos auxiliares
    rm -f "/etc/SSHPlus/senha/$USR_EX" 2>/dev/null
    rm -f "/etc/usuarios/$USR_EX" 2>/dev/null

    # Atualiza o banco de usuarios local (usa /etc/xis/ em vez de /sys/xis/)
    if [ -f /etc/xis/usuarios.db ]; then
        grep -v "^${USR_EX}[[:space:]]" /etc/xis/usuarios.db > /tmp/usuarios_tmp.db
        mv /tmp/usuarios_tmp.db /etc/xis/usuarios.db
    fi

    echo "1"
    exit 0
else
    echo "2"
    exit 2
fi
