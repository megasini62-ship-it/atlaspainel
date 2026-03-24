#!/usr/bin/python3
# -*- coding: utf-8 -*-
# suspend.py - Suspende (bloqueia) usuarios SSH listados em um arquivo
# Uso: python3 suspend.py <nome_do_arquivo>
# O arquivo deve estar em /root/ e conter um login por linha

import os
import sys

if len(sys.argv) != 2:
    print("Uso: python3 suspend.py <nome_do_arquivo>")
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
    login = linha.split()[0]  # Pega so o primeiro campo (login)
    # Usa o novo script atlassuspend.sh que BLOQUEIA sem excluir
    os.system("/etc/xis/atlassuspend.sh " + login)

# Limpa o arquivo
if os.path.exists(caminho_arquivo):
    os.remove(caminho_arquivo)
