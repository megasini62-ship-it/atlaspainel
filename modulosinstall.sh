#!/bin/bash

# Diretório de trabalho
WORK_DIR="/etc/xis"
cd $WORK_DIR

echo "Iniciando instalação dos módulos..."

# Função para verificar download
download_file() {
    local url=$1
    local output=$2
    
    echo "Baixando $output..."
    wget -q --show-progress -O "$output" "$url"
    
    if [ $? -eq 0 ]; then
        echo "✓ $output baixado com sucesso"
        chmod 777 "$output"
        return 0
    else
        echo "✗ Erro ao baixar $output"
        return 1
    fi
}

# Remover arquivos antigos
echo "Removendo arquivos antigos..."
rm -f atlasdata.sh atlascreate.sh atlasteste.sh atlasremove.sh delete.py sincronizar.py add.sh rem.sh addteste.sh addsinc.sh remsinc.sh verificador.py

# Lista de arquivos para download com URLs corrigidas
declare -A FILES=(
    ["atlascreate.sh"]="https://raw.githubusercontent.com/megasini62-ship-it/atlaspainel/main/atlascreate.sh"
    ["add.sh"]="https://raw.githubusercontent.com/megasini62-ship-it/atlaspainel/main/add.sh"
    ["remsinc.sh"]="https://raw.githubusercontent.com/megasini62-ship-it/atlaspainel/main/remsinc.sh"
    ["addsinc.sh"]="https://raw.githubusercontent.com/megasini62-ship-it/atlaspainel/main/addsinc.sh"
    ["rem.sh"]="https://raw.githubusercontent.com/megasini62-ship-it/atlaspainel/main/rem.sh"
    ["atlasteste.sh"]="https://raw.githubusercontent.com/megasini62-ship-it/atlaspainel/main/atlasteste.sh"
    ["addteste.sh"]="https://raw.githubusercontent.com/megasini62-ship-it/atlaspainel/main/addteste.sh"  # URL corrigida
    ["atlasremove.sh"]="https://raw.githubusercontent.com/megasini62-ship-it/atlaspainel/main/atlasremove.sh"
    ["delete.py"]="https://raw.githubusercontent.com/megasini62-ship-it/atlaspainel/main/delete.py"
    ["atlasdata.sh"]="https://raw.githubusercontent.com/megasini62-ship-it/atlaspainel/main/atlasdata.sh"
    ["sincronizar.py"]="https://raw.githubusercontent.com/megasini62-ship-it/atlaspainel/main/sincronizar.py"
    ["verificador.py"]="https://raw.githubusercontent.com/megasini62-ship-it/atlaspainel/main/verificador.py"  # URL corrigida
)

# Baixar todos os arquivos
SUCCESS=true
for file in "${!FILES[@]}"; do
    if ! download_file "${FILES[$file]}" "$file"; then
        SUCCESS=false
    fi
done

# Instalar dos2unix se necessário
if ! command -v dos2unix &> /dev/null; then
    echo "Instalando dos2unix..."
    apt-get update -qq
    apt-get install dos2unix -y -qq
fi

# Converter rem.sh para formato Unix
echo "Convertendo rem.sh para formato Unix..."
dos2unix rem.sh 2>/dev/null || echo "Aviso: Não foi possível converter rem.sh"

# Verificar se todos os downloads foram bem-sucedidos
if [ "$SUCCESS" = true ]; then
    echo "✓ Todos os módulos foram instalados com sucesso!"
    
    # Executar verificador.py se existir
    if [ -f "verificador.py" ]; then
        echo "Executando verificador.py..."
        python3 verificador.py
    fi
    
    # Listar arquivos instalados
    echo ""
    echo "Arquivos instalados em $WORK_DIR:"
    ls -la *.sh *.py 2>/dev/null | awk '{print "  - " $9}'
    
else
    echo "✗ Alguns módulos falharam ao baixar. Verifique sua conexão com a internet."
    exit 1
fi

echo ""
echo "Instalação concluída!"
