#!/usr/bin/python3
# -*- coding: utf-8 -*-
# delete.py - Remove/exclui usuarios SSH listados em um arquivo
# Uso: python3 delete.py <nome_do_arquivo>
# O arquivo deve estar em /root/ e conter:
#   - Formato 1 (com UUID): uuid login
#   - Formato 2 (sem UUID): login

import os
import sys

if len(sys.argv) != 2:
    print("Uso: python3 delete.py <nome_do_arquivo>")
    sys.exit(1)

nome_arquivo = sys.argv[1]

# CORRECAO: Busca o arquivo em /root/ (onde o painel envia)
caminho_arquivo = "/root/" + nome_arquivo
if not os.path.exists(caminho_arquivo):
    # Tenta tambem no diretorio atual como fallback
    if os.path.exists(nome_arquivo):
        caminho_arquivo = nome_arquivo
    else:
        print("Erro: Arquivo nao encontrado: " + nome_arquivo)
        sys.exit(1)

with open(caminho_arquivo, 'r') as arquivo:
    linhas = arquivo.readlines()
    linhas = [linha.strip() for linha in linhas if linha.strip()]

for linha in linhas:
    colunas = linha.split()
    if len(colunas) >= 2:
        # Formato: uuid login - usa rem.sh (remove V2Ray + usuario)
        # CORRECAO: usa caminho absoluto /etc/xis/
        os.system("/etc/xis/remsinc.sh " + colunas[0] + " " + colunas[1])
    elif len(colunas) == 1:
        # Formato: login - usa atlasremove.sh (remove so usuario)
        # CORRECAO: usa caminho absoluto /etc/xis/
        os.system("/etc/xis/atlasremove.sh " + colunas[0])

# Limpa o arquivo
if os.path.exists(caminho_arquivo):
    os.remove(caminho_arquivo)

# Reinicia v2ray
os.system("sudo systemctl restart v2ray 2>/dev/null")
