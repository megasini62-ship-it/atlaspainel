#!/bin/bash
# remsinc.sh - Remove usuario V2Ray + SSH (versao sincrona, sem restart v2ray)
# Uso: ./remsinc.sh <uuid> <login>

delete_id() {
    if [ "$#" -ne 2 ]; then
        echo "Uso: $0 <uuid> <login>"
        exit 1
    fi

    uuidel="$1"
    login="$2"

    if [ -f /etc/v2ray/config.json ] && grep -q "$uuidel" /etc/v2ray/config.json; then
        tmpfile=$(mktemp)
        jq --arg uuid "$uuidel" 'del(.inbounds[0].settings.clients[] | select(.id == $uuid))' /etc/v2ray/config.json > "$tmpfile" && mv "$tmpfile" /etc/v2ray/config.json
        echo "UUID $uuidel removido"
    fi

    # CORRECAO: usa caminho absoluto
    bash /etc/xis/atlasremove.sh "$login"
}

delete_id "$1" "$2"
