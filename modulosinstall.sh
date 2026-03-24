#!/bin/bash

# Diretório de trabalho
WORK_DIR="/etc/xis"
mkdir -p $WORK_DIR
cd $WORK_DIR

# URL base do repositório
REPO_URL="https://raw.githubusercontent.com/megasini62-ship-it/atlaspainel/main"

echo "========================================="
echo "Iniciando instalação dos módulos"
echo "Diretório: $WORK_DIR"
echo "========================================="

# Função para baixar arquivo com verificação
download_file() {
    local url=$1
    local output=$2
    
    echo "Baixando: $output"
    wget -q --show-progress -O "$output" "$url" 2>&1
    
    if [ -f "$output" ] && [ -s "$output" ]; then
        local size=$(stat -c%s "$output")
        echo "✓ $output baixado com sucesso ($size bytes)"
        chmod 755 "$output" 2>/dev/null
        return 0
    else
        echo "✗ Falha ao baixar $output"
        return 1
    fi
}

# Fazer backup dos arquivos antigos antes de limpar
if ls *.sh *.py 1>/dev/null 2>&1; then
    BACKUP_DIR="/etc/xis_backup_$(date +%Y%m%d_%H%M%S)"
    echo "Fazendo backup em $BACKUP_DIR..."
    mkdir -p "$BACKUP_DIR"
    cp *.sh *.py "$BACKUP_DIR/" 2>/dev/null
    echo "✓ Backup criado em $BACKUP_DIR"
fi

# Limpar arquivos antigos
echo "Limpando arquivos antigos..."
rm -f *.sh *.py 2>/dev/null

# =========================================
# ARQUIVOS ORIGINAIS (já existentes no repo)
# =========================================
echo ""
echo "Baixando arquivos principais..."

download_file "$REPO_URL/atlascreate.sh" "atlascreate.sh"
download_file "$REPO_URL/add.sh" "add.sh"
download_file "$REPO_URL/remsinc.sh" "remsinc.sh"
download_file "$REPO_URL/addsinc.sh" "addsinc.sh"
download_file "$REPO_URL/rem.sh" "rem.sh"
download_file "$REPO_URL/atlasteste.sh" "atlasteste.sh"
download_file "$REPO_URL/addteste.sh" "addteste.sh"
download_file "$REPO_URL/atlasremove.sh" "atlasremove.sh"
download_file "$REPO_URL/delete.py" "delete.py"
download_file "$REPO_URL/atlasdata.sh" "atlasdata.sh"
download_file "$REPO_URL/sincronizar.py" "sincronizar.py"
download_file "$REPO_URL/verificador.py" "verificador.py"

# =========================================
# NOVOS ARQUIVOS (correções de bugs)
# =========================================
echo ""
echo "========================================="
echo "Baixando novos módulos de correção..."
echo "========================================="

# atlassuspend.sh - NOVO: Suspende (bloqueia) usuário SSH sem excluir
# Usado quando o painel suspende uma revenda - o usuário fica bloqueado mas não é deletado
download_file "$REPO_URL/atlassuspend.sh" "atlassuspend.sh"

# atlasreativar.sh - NOVO: Reativa (desbloqueia) usuário SSH suspenso
# Usado quando o painel reativa uma revenda - desbloqueia o usuário ou recria se não existir
download_file "$REPO_URL/atlasreativar.sh" "atlasreativar.sh"

# suspend.py - NOVO: Suspende usuários em lote (lê arquivo com lista de logins)
# Usado pelo painel para suspender todos os usuários de uma revenda de uma vez
download_file "$REPO_URL/suspend.py" "suspend.py"

# =========================================
# CONFIGURAÇÕES
# =========================================

# Instalar dos2unix se necessário
echo ""
echo "Configurando permissões..."
apt-get install -y dos2unix > /dev/null 2>&1

# Converter arquivos para formato Unix (evita erros de \r\n)
for file in *.sh *.py 2>/dev/null; do
    if [ -f "$file" ]; then
        dos2unix "$file" > /dev/null 2>&1
        echo "✓ Convertido: $file"
    fi
done

# Garantir permissão de execução em todos os scripts
chmod +x *.sh *.py 2>/dev/null

# =========================================
# CRIAR DIRETÓRIOS AUXILIARES NECESSÁRIOS
# =========================================
echo ""
echo "Criando diretórios auxiliares..."

# Diretório para senhas dos usuários SSH
mkdir -p /etc/SSHPlus/senha
echo "✓ /etc/SSHPlus/senha"

# Banco de dados local de usuários (CORRIGIDO: /etc/xis/ em vez de /sys/xis/)
# Se existir dados antigos em /sys/xis/, migra para /etc/xis/
if [ -f /sys/xis/usuarios.db ] 2>/dev/null; then
    cp /sys/xis/usuarios.db /etc/xis/usuarios.db 2>/dev/null
    echo "✓ Migrado /sys/xis/usuarios.db para /etc/xis/usuarios.db"
fi

# Cria o arquivo se não existir
touch /etc/xis/usuarios.db 2>/dev/null
echo "✓ /etc/xis/usuarios.db"

# =========================================
# VERIFICAÇÃO FINAL
# =========================================
echo ""
echo "========================================="
echo "Arquivos instalados em $WORK_DIR:"
echo "========================================="
ls -lah *.sh *.py 2>/dev/null | awk '{print "  " $9 " (" $5 ")"}'

# Contar arquivos
total=$(ls -1 *.sh *.py 2>/dev/null | wc -l)
echo ""
echo "Total de arquivos: $total"

# Verificar se os 3 novos arquivos existem
echo ""
echo "========================================="
echo "Verificação dos novos módulos:"
echo "========================================="

ERROS=0

if [ -f "atlassuspend.sh" ] && [ -s "atlassuspend.sh" ]; then
    echo "✓ atlassuspend.sh  - Módulo de SUSPENSÃO (bloquear usuário)"
else
    echo "✗ atlassuspend.sh  - FALTANDO! Suspensão de revendas não vai funcionar!"
    ERROS=$((ERROS+1))
fi

if [ -f "atlasreativar.sh" ] && [ -s "atlasreativar.sh" ]; then
    echo "✓ atlasreativar.sh - Módulo de REATIVAÇÃO (desbloquear usuário)"
else
    echo "✗ atlasreativar.sh - FALTANDO! Reativação de revendas não vai funcionar!"
    ERROS=$((ERROS+1))
fi

if [ -f "suspend.py" ] && [ -s "suspend.py" ]; then
    echo "✓ suspend.py       - Módulo de SUSPENSÃO em lote"
else
    echo "✗ suspend.py       - FALTANDO! Suspensão em lote não vai funcionar!"
    ERROS=$((ERROS+1))
fi

if [ -f "atlasremove.sh" ] && [ -s "atlasremove.sh" ]; then
    echo "✓ atlasremove.sh   - Módulo de EXCLUSÃO (remover usuário)"
else
    echo "✗ atlasremove.sh   - FALTANDO!"
    ERROS=$((ERROS+1))
fi

if [ -f "delete.py" ] && [ -s "delete.py" ]; then
    echo "✓ delete.py        - Módulo de EXCLUSÃO em lote"
else
    echo "✗ delete.py        - FALTANDO!"
    ERROS=$((ERROS+1))
fi

if [ -f "sincronizar.py" ] && [ -s "sincronizar.py" ]; then
    echo "✓ sincronizar.py   - Módulo de SINCRONIZAÇÃO/REATIVAÇÃO em lote"
else
    echo "✗ sincronizar.py   - FALTANDO!"
    ERROS=$((ERROS+1))
fi

if [ -f "atlascreate.sh" ] && [ -s "atlascreate.sh" ]; then
    echo "✓ atlascreate.sh   - Módulo de CRIAÇÃO de usuário"
else
    echo "✗ atlascreate.sh   - FALTANDO!"
    ERROS=$((ERROS+1))
fi

echo "========================================="

if [ $ERROS -eq 0 ]; then
    echo "✓ Todos os módulos instalados com sucesso!"
else
    echo "✗ ATENÇÃO: $ERROS módulo(s) faltando!"
    echo "  Verifique se os arquivos existem no repositório GitHub."
fi

echo "========================================="

# Executar verificador se existir
if [ -f "verificador.py" ]; then
    echo ""
    echo "Executando verificador.py..."
    python3 verificador.py
fi

echo ""
echo "Instalação concluída!"
