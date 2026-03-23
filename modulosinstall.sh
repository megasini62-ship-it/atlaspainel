#!/bin/bash
rm -f atlasdata.sh atlascreate.sh atlasteste.sh atlasremove.sh delete.py sincronizar.py add.sh rem.sh addteste.sh addsinc.sh remsinc.sh
wget -O atlascreate.sh "https://raw.githubusercontent.com/megasini62-ship-it/atlaspainel/main/atlascreate.sh"
wget -O add.sh "https://raw.githubusercontent.com/megasini62-ship-it/atlaspainel/main/add.sh"
wget -O remsinc.sh "https://raw.githubusercontent.com/megasini62-ship-it/atlaspainel/main/remsinc.sh"
wget -O addsinc.sh "https://raw.githubusercontent.com/megasini62-ship-it/atlaspainel/main/addsinc.sh"
wget -O rem.sh "https://raw.githubusercontent.com/megasini62-ship-it/atlaspainel/main/rem.sh"
wget -O atlasteste.sh "https://raw.githubusercontent.com/megasini62-ship-it/atlaspainel/main/atlasteste.sh"
wget -O addteste.sh "https://raw.githubusercontent.com//megasini62-ship-it/atlaspainel/main/addteste.sh"
wget -O atlasremove.sh "https://raw.githubusercontent.com/megasini62-ship-it/atlaspainel/main/atlasremove.sh"
wget -O delete.py "https://raw.githubusercontent.com/megasini62-ship-it/atlaspainel/main/delete.py"
wget -O atlasdata.sh "https://raw.githubusercontent.com/megasini62-ship-it/atlaspainel/main/atlasdata.sh"
wget -O sincronizar.py "https://raw.githubusercontent.com/megasini62-ship-it/atlaspainel/main/sincronizar.py"
chmod 777 atlascreate.sh add.sh remsinc.sh addsinc.sh rem.sh atlasteste.sh addteste.sh atlasremove.sh delete.py atlasdata.sh sincronizar.py
apt install dos2unix
dos2unix rem.sh
wget "https://raw.githubusercontent.com/megasini62-ship-it/atlaspainel//main/verificador.py" -O verificador.py 
python3 verificador.py
