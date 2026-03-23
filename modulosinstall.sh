#!/bin/bash

# Diretório de trabalho
WORK_DIR="/etc/xis"
mkdir -p $WORK_DIR
cd $WORK_DIR

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

# Limpar arquivos antigos primeiro
echo "Limpando arquivos antigos..."
rm -f *.sh *.py 2>/dev/null

# Lista completa de arquivos para baixar
echo ""
echo "Baixando arquivos principais..."

# Baixar cada arquivo individualmente com URL correta
download_file "https://raw.githubusercontent.com/megasini62-ship-it/atlaspainel/main/atlascreate.sh" "atlascreate.sh"
download_file "https://raw.githubusercontent.com/megasini62-ship-it/atlaspainel/main/add.sh" "add.sh"
download_file "https://raw.githubusercontent.com/megasini62-ship-it/atlaspainel/main/remsinc.sh" "remsinc.sh"
download_file "https://raw.githubusercontent.com/megasini62-ship-it/atlaspainel/main/addsinc.sh" "addsinc.sh"
download_file "https://raw.githubusercontent.com/megasini62-ship-it/atlaspainel/main/rem.sh" "rem.sh"
download_file "https://raw.githubusercontent.com/megasini62-ship-it/atlaspainel/main/atlasteste.sh" "atlasteste.sh"
download_file "https://raw.githubusercontent.com/megasini62-ship-it/atlaspainel/main/addteste.sh" "addteste.sh"
download_file "https://raw.githubusercontent.com/megasini62-ship-it/atlaspainel/main/atlasremove.sh" "atlasremove.sh"
download_file "https://raw.githubusercontent.com/megasini62-ship-it/atlaspainel/main/delete.py" "delete.py"
download_file "https://raw.githubusercontent.com/megasini62-ship-it/atlaspainel/main/atlasdata.sh" "atlasdata.sh"
download_file "https://raw.githubusercontent.com/megasini62-ship-it/atlaspainel/main/sincronizar.py" "sincronizar.py"
download_file "https://raw.githubusercontent.com/megasini62-ship-it/atlaspainel/main/verificador.py" "verificador.py"

# Instalar dos2unix se necessário
echo ""
echo "Configurando permissões..."
apt-get install -y dos2unix > /dev/null 2>&1

# Converter arquivos para formato Unix
for file in *.sh *.py 2>/dev/null; do
    if [ -f "$file" ]; then
        dos2unix "$file" > /dev/null 2>&1
        echo "✓ Convertido: $file"
    fi
done

# Listar todos os arquivos instalados
echo ""
echo "========================================="
echo "Arquivos instalados em $WORK_DIR:"
echo "========================================="
ls -lah *.sh *.py 2>/dev/null | awk '{print "  " $9 " (" $5 ")"}'

# Contar arquivos
total=$(ls -1 *.sh *.py 2>/dev/null | wc -l)
echo ""
echo "Total de arquivos: $total"
echo "========================================="

# Executar verificador se existir
if [ -f "verificador.py" ]; then
    echo ""
    echo "Executando verificador.py..."
    python3 verificador.py
fi

echo ""
echo "Instalação concluída!"
