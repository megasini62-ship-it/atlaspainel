#!/bin/bash
# atlassuspend.sh - Suspende (bloqueia) um usuário SSH sem excluí-lo
# Uso: ./atlassuspend.sh <usuario>
# O usuario continua existindo no sistema, mas nao consegue fazer login

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

    # Bloqueia a conta (expira imediatamente)
    chage -E 0 "$USR_EX" 2>/dev/null
    usermod -L "$USR_EX" 2>/dev/null

    echo "1"
    exit 0
else
    echo "2"
    exit 2
fi
