#!/bin/bash
# addsinc.sh - Adiciona/recria usuario V2Ray + SSH (usado na reativacao/sincronizacao)
# Uso: ./addsinc.sh <uuid> <login> <senha> <dias> <limite>

if [ "$#" -ne 5 ]; then
    echo "Uso: $0 <uuid> <login> <senha> <dias> <limite>"
    exit 1
fi

uuid="$1"
email="$2"
senha="$3"
validade="$4"
limite="$5"
config_file="/etc/v2ray/config.json"

# Verifica se o UUID ja existe na configuracao
if [ -f "$config_file" ] && grep -q "\"id\": \"$uuid\"" "$config_file"; then
    echo "2"
else
    if [ -f "$config_file" ]; then
        new_client='{"id": "'$uuid'", "alterId": 0, "email": "'$email@gmail.com'"}'
        tmpfile=$(mktemp)
        jq --argjson newclient "$new_client" '.inbounds[0].settings.clients += [$newclient]' "$config_file" > "$tmpfile" && mv "$tmpfile" "$config_file"
    fi
    echo "1"
fi

# CORRECAO: usa caminho absoluto para atlasreativar.sh (desbloqueia ou recria)
bash /etc/xis/atlasreativar.sh "$email" "$senha" "$validade" "$limite"
