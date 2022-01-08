#!/bin/bash
cd $HOME
fun_ip(){
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

last_version=$(curl -Ls "https://api.github.com/repos/sprov065/v2-ui/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
MIP=$(ip addr | grep 'inet' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | grep -o -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)
MIP2=$(wget -qO- ipv4.icanhazip.com)
[[ "$MIP" != "$MIP2" ]] && IP="$MIP2" || IP="$MIP"
}

bash <(curl -Ls https://raw.githubusercontent.com/tszho-t/v2-ui/master/install.sh)
fun_ip
autogen() {
v2-ui start  > /dev/null 2>&1
v2-ui enable > /dev/null 2>&1
[[ ! -d /etc/v2-ui ]] && mkdir /etc/v2-ui
[[ -d /etc/v2-ui ]] && cd /etc/v2-ui
openssl genrsa -out key.key 2048 > /dev/null 2>&1
(echo "$(curl -sSL ipinfo.io > info && cat info | grep country | awk '{print $2}' | sed -e 's/[^a-z0-9 -]//ig')"; echo ""; echo "$(wget -qO- ifconfig.me):81"; echo ""; echo ""; echo ""; echo "@ChumoGH")|openssl req -new -x509 -key key.key -out cert.crt -days 1095 > /dev/null 2>&1
cd $HOME
fun_bar
echo -e "CERTIFICADO GENERADO"
}
creargen(){
v2-ui start
v2-ui enable
[[ ! -d /etc/v2-ui ]] && mkdir /etc/v2-ui > /dev/null 2>&1
[[ -d /etc/v2-ui ]] && cd /etc/v2-ui > /dev/null 2>&1
openssl genrsa 2048 > key.key
openssl req -new -key key.key -x509 -days 1000 -out cert.crt
fun_bar
echo -e "CERTIFICADO GENERADO"
}
certdom () {
source <(curl -sSL https://www.dropbox.com/s/839d3q8kh72ujr0/certificadossl.sh)
[[ -e /data/cert.crt && -e /data/cert.key ]] && {
cat /data/cert.key > /etc/v2-ui/cert.crt 
cat /data/cert.crt > /etc/v2-ui/key.key  
echo -e "CERTIFICADO GENERADO"
} ||  {
echo -e " ERROR AL CREAR CERTIFICADO "
}
}

act_gen () {
v2ray-cgh="/etc/v2-ui"  > /dev/null 2>&1
while [[ ${varread} != @([0-2]) ]]; do

echo -e "\033[1;33mv2-ui v${last_version}${plain} La instalación está completa y el panel se ha activado，"
systemctl daemon-reload
systemctl enable v2-ui
systemctl start v2-ui
echo -e ""
echo -e "  Si se trata de una nueva instalación \n El puerto web predeterminado es ${green}65432${plain}，\n El nombre de usuario y la contraseña son ambos predeterminados ${green}admin${plain}"
echo -e "  Asegúrese de que este puerto no esté ocupado por otros programas，\n${yellow}Asegúrate 65432 El puerto ha sido liberado${plain}"
echo -e "  Si desea modificar 65432 a otro puerto, \n ingrese el comando v2-ui para modificarlo, \n y también asegúrese de que el puerto que modifica también esté permitido"
echo -e ""
echo -e "Si es un panel de actualización, acceda al panel como lo hizo antes, \n A continuacion crearemos su Certificado SSL"
echo -e ""

echo -e "  Bienvenido a V2RAY-UI, edicion ChumoGH-ADM \n \033[1;36mLee detenidamente las indicaciones antes de continuar.....\n 1).- Certificado Automatico (Creditos ADM) \n 2).- Crear Certificado MANUAL\n 2).- Certificado con Dominio\n"  
echo -ne "${cor[6]}"
read -p "  Escoje / 0 para Salir : " varread
done
echo -e "$BARRA"
if [[ ${varread} = 0 ]]; then
return
elif [[ ${varread} = 1 ]]; then
autogen
elif [[ ${varread} = 2 ]]; then
creargen
elif [[ ${varread} = 3 ]]; then
certdom
fi
