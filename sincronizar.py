#!/usr/bin/python3
# -*- coding: utf-8 -*-
# sincronizar.py - Recria/reativa usuarios SSH listados em um arquivo
# Uso: python3 sincronizar.py <nome_do_arquivo>
# O arquivo deve estar em /root/ e conter:
#   - Formato 1 (com UUID, 5+ campos): login senha dias limite uuid
#   - Formato 2 (sem UUID, 4 campos): login senha dias limite

import os
import sys

if len(sys.argv) != 2:
    print("Uso: python3 sincronizar.py <nome_do_arquivo>")
    sys.exit(1)

nome_arquivo = sys.argv[1]

# CORRECAO: Busca o arquivo em /root/ (onde o painel envia)
caminho_arquivo = "/root/" + nome_arquivo
if not os.path.exists(caminho_arquivo):
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
    if len(colunas) >= 5:
        # Formato: login senha dias limite uuid
        # CORRECAO: usa caminho absoluto /etc/xis/
        os.system("/etc/xis/addsinc.sh " + colunas[4] + " " + colunas[0] + " " + colunas[1] + " " + colunas[2] + " " + colunas[3])
    elif len(colunas) >= 4:
        # Formato: login senha dias limite
        # CORRECAO: usa caminho absoluto /etc/xis/
        os.system("/etc/xis/atlasreativar.sh " + colunas[0] + " " + colunas[1] + " " + colunas[2] + " " + colunas[3])

# Limpa o arquivo
if os.path.exists(caminho_arquivo):
    os.remove(caminho_arquivo)

# Reinicia v2ray
os.system("sudo systemctl restart v2ray 2>/dev/null")
