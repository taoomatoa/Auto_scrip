BIBlack='\033[1;90m'      # Black
BIRed='\033[1;91m'        # Red
BIGreen='\033[1;92m'      # Green
BIYellow='\033[1;93m'     # Yellow
BIBlue='\033[1;94m'       # Blue
BIPurple='\033[1;95m'     # Purple
BICyan='\033[1;96m'       # Cyan
BIWhite='\033[1;97m'      # White
UWhite='\033[4;37m'       # White
On_IPurple='\033[0;105m'  #
On_IRed='\033[0;101m'
IBlack='\033[0;90m'       # Black
IRed='\033[0;91m'         # Red
IGreen='\033[0;92m'       # Green
IYellow='\033[0;93m'      # Yellow
IBlue='\033[0;94m'        # Blue
IPurple='\033[0;95m'      # Purple
ICyan='\033[0;96m'        # Cyan
IWhite='\033[0;97m'       # White
NC='\e[0m'
m="\033[0;1;36m"
y="\033[0;1;37m"
yy="\033[0;1;32m"
yl="\033[0;1;33m"
wh="\033[0m"
## Foreground
DEFBOLD='\e[39;1m'
RB='\e[31;1m'
GB='\e[32;1m'
YB='\e[33;1m'
BB='\e[34;1m'
MB='\e[35;1m'
CB='\e[35;1m'
WB='\e[37;1m'

# // Export Color & Information
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[0;33m'
export BLUE='\033[0;34m'
export PURPLE='\033[0;35m'
export CYAN='\033[0;36m'
export LIGHT='\033[0;37m'
export NC='\033[0m'

# // Export Banner Status Information
export EROR="[${RED} EROR ${NC}]"
export INFO="[${YELLOW} INFO ${NC}]"
export OKEY="[${GREEN} OKEY ${NC}]"
export PENDING="[${YELLOW} PENDING ${NC}]"
export SEND="[${YELLOW} SEND ${NC}]"
export RECEIVE="[${YELLOW} RECEIVE ${NC}]"

# // Export Align
export BOLD="\e[1m"
export WARNING="${RED}\e[5m"
export UNDERLINE="\e[4m"

# // Exporting URL Host
export Server_URL="raw.githubusercontent.com/taoomatoa/Auto_scrip/main/test"
export Server1_URL="raw.githubusercontent.com/taoomatoa/Auto_scrip/main/limit"
export Server_Port="443"
export Server_IP="underfined"
export Script_Mode="Stable"
export Auther=".geovpn"

# // Root Checking
if [ "${EUID}" -ne 0 ]; then
		echo -e "${EROR} Please Run This Script As Root User !"
		exit 1
fi

# // Exporting IP Address
export IP=$( curl -s https://ipinfo.io/ip/ )

# // Exporting Network Interface
export NETWORK_IFACE="$(ip route show to default | awk '{print $5}')"

# // Clear
clear
clear && clear && clear
clear;clear;clear
cek=$(service ssh status | grep active | cut -d ' ' -f5)
if [ "$cek" = "active" ]; then
stat=-f5
else
stat=-f7
fi
ssh=$(service ssh status | grep active | cut -d ' ' $stat)
if [ "$ssh" = "active" ]; then
ressh="${green}ON${NC}"
else
ressh="${red}OFF${NC}"
fi
sshstunel=$(service stunnel5 status | grep active | cut -d ' ' $stat)
if [ "$sshstunel" = "active" ]; then
resst="${green}ON${NC}"
else
resst="${red}OFF${NC}"
fi
sshws=$(service ws-stunnel status | grep active | cut -d ' ' $stat)
if [ "$sshws" = "active" ]; then
ressshws="${green}ON${NC}"
else
ressshws="${red}OFF${NC}"
fi
ngx=$(service nginx status | grep active | cut -d ' ' $stat)
if [ "$ngx" = "active" ]; then
resngx="${green}ON${NC}"
else
resngx="${red}OFF${NC}"
fi
dbr=$(service dropbear status | grep active | cut -d ' ' $stat)
if [ "$dbr" = "active" ]; then
resdbr="${green}ON${NC}"
else
resdbr="${red}OFF${NC}"
fi
v2r=$(service xray status | grep active | cut -d ' ' $stat)
if [ "$v2r" = "active" ]; then
resv2r="${green}ON${NC}"
else
resv2r="${red}OFF${NC}"
fi
function addhost(){
clear
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo ""
read -rp "Domain/Host: " -e host
echo ""
if [ -z $host ]; then
echo "????"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
read -n 1 -s -r -p "Press any key to back on menu"
setting-menu
else
rm -fr /etc/xray/domain
echo "IP=$host" > /var/lib/scrz-prem/ipvps.conf
echo $host > /etc/xray/domain
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo "Dont forget to renew gen-ssl"
echo ""
read -n 1 -s -r -p "Press any key to back on menu"
menu
fi
}
function genssl(){
clear
systemctl stop nginx
systemctl stop xray
domain=$(cat /var/lib/scrz-prem/ipvps.conf | cut -d'=' -f2)
Cek=$(lsof -i:80 | cut -d' ' -f1 | awk 'NR==2 {print $1}')
if [[ ! -z "$Cek" ]]; then
sleep 1
echo -e "[ ${red}WARNING${NC} ] Detected port 80 used by $Cek " 
systemctl stop $Cek
sleep 2
echo -e "[ ${green}INFO${NC} ] Processing to stop $Cek " 
sleep 1
fi
echo -e "[ ${green}INFO${NC} ] Starting renew gen-ssl... " 
sleep 2
/root/.acme.sh/acme.sh --upgrade
/root/.acme.sh/acme.sh --upgrade --auto-upgrade
/root/.acme.sh/acme.sh --set-default-ca --server letsencrypt
/root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256
~/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /etc/xray/xray.crt --keypath /etc/xray/xray.key --ecc
echo -e "[ ${green}INFO${NC} ] Renew gen-ssl done... " 
sleep 2
echo -e "[ ${green}INFO${NC} ] Starting service $Cek " 
sleep 2
echo $domain > /etc/xray/domain
systemctl start nginx
systemctl start xray
echo -e "[ ${green}INFO${NC} ] All finished... " 
sleep 0.5
echo ""
read -n 1 -s -r -p "Press any key to back on menu"
menu
}
export sem=$( curl -s https://raw.githubusercontent.com/taoomatoa/Auto_scrip/main/test/versions)
export pak=$( cat /home/.ver)
IPVPS=$(curl -s ipinfo.io/ip )
IPVPS=$(curl -sS ipv4.icanhazip.com)
IPVPS=$(curl -sS ifconfig.me )
ISPVPS=$( curl -s ipinfo.io/org )
daily_usage=$(vnstat -d --oneline | awk -F\; '{print $6}' | sed 's/ //')
monthly_usage=$(vnstat -m --oneline | awk -F\; '{print $11}' | sed 's/ //')
ram_used=$(free -m | grep Mem: | awk '{print $3}')
total_ram=$(free -m | grep Mem: | awk '{print $2}')
ram_usage=$(echo "scale=2; ($ram_used / $total_ram) * 100" | bc | cut -d. -f1)
# OS Uptime
uptime="$(uptime -p | cut -d " " -f 2-10)"
# TOTAL ACC XRAYS WS & XTLS
vmess=$(grep -c -E "^#vmsg $user" "/etc/xray/config.json")
vless=$(grep -c -E "^#vlsg $user" "/etc/xray/config.json")
tr=$(grep -c -E "^#trg $user" "/etc/xray/config.json")
ss=$(grep -c -E "^#ssg $user" "/etc/xray/config.json")
ssh="$(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd | wc -l)"
# Getting CPU Information
cpu_usage1="$(ps aux | awk 'BEGIN {sum=0} {sum+=$3}; END {print sum}')"
cpu_usage="$((${cpu_usage1/\.*/} / ${corediilik:-1}))"
cpu_usage+="%"
cname=$(awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo)
cores=$(awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo)
freq=$(awk -F: ' /cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo)

clear
echo -e " ${z}╭═══════════════════════════════════════════════════╮${NC}"
echo -e " ${z}│$NC\033[41m  ${BOLD}              TUNNELING TAOOMATOA                $NC${z}│$NC"
echo -e " ${z}╰═══════════════════════════════════════════════════╯${NC}"
echo -e " ${z}╭═══════════════════════════════════════════════════╮${NC}"
echo -e " ${z}│$NC$BIBlue ⇲ $NC OS ${NC}      :$NC "$(hostnamectl | grep "Operating System" | cut -d ' ' -f5-)  
echo -e " ${z}│$NC$BIBlue ⇲ $NC RAM ${NC}     :$NC ${BIWhite}${ram_used}MB / ${total_ram}MB (${ram_usage}%) ${NC}" 
echo -e " ${z}│$NC$BIBlue ⇲ $NC UPTIME ${NC}  :$NC ${BIWhite}$uptime${NC}"
echo -e " ${z}│$NC$BIBlue ⇲ $NC CITY ${NC}    :$NC $(wget -qO- ipinfo.io/region)"
echo -e " ${z}│$NC$BIBlue ⇲ $NC ISP VPS ${NC} :$NC ${BIWhite}$ISPVPS${NC}"  
echo -e " ${z}│$NC$BIBlue ⇲ $NC IP ${NC}      :$NC$y ${BIWhite}$IPVPS${NC}"  
echo -e " ${z}│$NC$BIBlue ⇲ $NC DOMAIN ${NC}  :$NC$y ${BIWhite}$(cat /etc/xray/domain)${NC}" 
echo -e " ${z}│$NC$BIBlue ⇲ $NC Daily Bandwidth ${NC} :  ${BIWhite}$daily_usage ${NC}"
echo -e " ${z}│$NC$BIBlue ⇲ $NC Total Bandwidth  ${NC}:  ${BIWhite}$monthly_usage ${NC}"
echo -e " ${z}╰═══════════════════════════════════════════════════╯${NC}"
echo -e " ${z} ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}" | lolcat
echo -e " ${z} $NC\033[0m ${BOLD}${White} SSH     VMESS     VLESS     TROJAN     SHADOWS$NC" 
echo -e " ${z} $NC\033[0m ${y}  $ssh        $vmess         $vless          $tr          $ss$NC"
echo -e " ${z} ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}" | lolcat
echo -e "     ${BICyan} SSH ${NC}: $ressh"" ${BICyan} NGINX ${NC}: $resngx"" ${BICyan}  XRAY ${NC}: $resv2r"" ${BICyan} TROJAN ${NC}: $resv2r"
echo -e "     		${BICyan} DROPBEAR ${NC}: $resdbr" "${BICyan} SSH-WS ${NC}: $ressshws"
echo -e " ${z} ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}" | lolcat
echo -e " ${z}   ╭━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╮${NC}"
echo -e " ${z}   │$NC  Version      ${NC} : $sem Last Update" 
echo -e " ${z}   ╰━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╯${NC}"

echo -e " ${z}╭═══════════════════════════════════════════════════╮${NC}"
echo -e " ${z}│  $NC ${BICyan}[${BIWhite}01${BICyan}] SSHWS${NC}		    ${z}│  $NC ${BICyan}[${BIWhite}11${BICyan}] ADD HOST/DOMAIN${NC} ${z}│"
echo -e " ${z}│  $NC ${BICyan}[${BIWhite}02${BICyan}] VMESS${NC}		    ${z}│  $NC ${BICyan}[${BIWhite}12${BICyan}] RENEW CERT ${NC}     ${z}│" 
echo -e " ${z}│  $NC ${BICyan}[${BIWhite}03${BICyan}] VLESS${NC}		    ${z}│  $NC ${BICyan}[${BIWhite}13${BICyan}] EDIT BANNER ${NC}    ${z}│"  
echo -e " ${z}│  $NC ${BICyan}[${BIWhite}04${BICyan}] TROJAN${NC}	    ${z}│  $NC ${BICyan}[${BIWhite}14${BICyan}] RUNNING STATUS ${NC}    ${z}│"
echo -e " ${z}│  $NC ${BICyan}[${BIWhite}05${BICyan}] SHADOWSOCKS${NC}	    ${z}│  $NC ${BICyan}[${BIWhite}15${BICyan}] USERBANDWIDTH ${NC}    ${z}│"
echo -e " ${z}│  $NC ${BICyan}[${BIWhite}06${BICyan}] EXP FILES${NC}	    ${z}│  $NC ${BICyan}[${BIWhite}16${BICyan}] SPEEDTEST ${NC}	    ${z}│"
echo -e " ${z}│  $NC ${BICyan}[${BIWhite}07${BICyan}] AUTO REBOOT${NC}	    ${z}│  $NC ${BICyan}[${BIWhite}17${BICyan}] CEKBANDWIDTH ${NC}    ${z}│"
echo -e " ${z}│  $NC ${BICyan}[${BIWhite}08${BICyan}] REBOOT${NC}	    ${z}│  $NC ${BICyan}[${BIWhite}18${BICyan}] LIMIT SPEED ${NC}    ${z}│"
echo -e " ${z}│  $NC ${BICyan}[${BIWhite}09${BICyan}] RESTART${NC}	    ${z}│  $NC ${BICyan}[${BIWhite}19${BICyan}] WEBMIN ${NC}	    ${z}│"
echo -e " ${z}│  $NC ${BICyan}[${BIWhite}10${BICyan}] BACKUP${NC}	    ${z}│  $NC ${BICyan}[${BIWhite}20${BICyan}] INFO SCRIPT ${NC}    ${z}│"
echo -e " ${z} ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}" | lolcat
echo -e " ${z}│  $NC ${BICyan}[${BIWhite}21${BICyan}] CLEAR LOG${NC}	    ${z}│  $NC ${BICyan}[${BIWhite}55${BICyan}] XRAY-CORE MENU${NC}    ${z}│"
echo -e " ${z}│  $NC ${BICyan}[${BIWhite}22${BICyan}] TASK MANAGER${NC}	    ${z}│  $NC ${BICyan}[${BIWhite}66${BICyan}] INSTALL BBRPLUS${NC}    ${z}│"
echo -e " ${z}│  $NC ${BICyan}[${BIWhite}23${BICyan}] DNS CHANGER${NC}	    ${z}│  $NC ${BICyan}[${BIWhite}77${BICyan}] SWAPRAM MENU${NC}    ${z}│"
echo -e " ${z}│  $NC ${BICyan}[${BIWhite}24${BICyan}] NETFLIX CHEC${NC}	    ${z}│  $NC ${BICyan}[${BIWhite}88${BICyan}] RESTORE${NC}	    ${z}│"
echo -e " ${z}│  $NC ${BICyan}[${BIWhite}25${BICyan}] TENDANG${NC}	    ${z}│  $NC ${BICyan}[${BIWhite}x ${BICyan}] EXIT${NC}	    ${z}│"
echo -e " ${z}╰═══════════════════════════════════════════════════╯${NC}"
echo
read -p " Select menu : " opt
echo -e ""
case $opt in
1) clear ; menu-ssh ;;
2) clear ; menu-vmess ;;
3) clear ; menu-vless ;;
4) clear ; menu-trojan ;;
5) clear ; menu-ss ;;
6) clear ; xp ;;
7) clear ; autoreboot ;;
8) clear ; reboot ;;
9) clear ; restart ;;
10) clear ; backup ;;
11) clear ; addhost ;;
12) clear ; genssl ;;
13) clear ; nano /etc/issue.net ;;
14) clear ; running ;;
15) clear ; cek-trafik ;;
16) clear ; cek-speed ;;
17) clear ; cek-bandwidth ;;
18) clear ; limit-speed ;;
19) clear ; wbm ;;
20) clear ; cat /root/log-install.txt ;;
21) clear ; clearlog ;;
22) clear ; gotop ;;
23) clear ; dns ;;
24) clear ; netf ;;
25) clear ; tendang ;;
55) clear ; wget -q -O /usr/bin/xraychanger "https://raw.githubusercontent.com/NevermoreSSH/Xcore-custompath/main/xraychanger.sh" && chmod +x /usr/bin/xraychanger && xraychanger ;;
66) clear ; bbr ;;
77) clear ; wget -q -O /usr/bin/swapram "https://raw.githubusercontent.com/NevermoreSSH/swapram/main/swapram.sh" && chmod +x /usr/bin/swapram && swapram ;;
88) clear ; restore ;;
#88) clear ; wget https://raw.githubusercontent.com/NevermoreSSH/Vergil/main2/addons/dns2.sh && chmod +x dns2.sh && ./dns2.sh ;;
#99) clear ; wget https://raw.githubusercontent.com/NevermoreSSH/Vergil/main/Tunnel/udp.sh && bash udp.sh ;;
#22) clear ; wget https://raw.githubusercontent.com/taoomatoa/Auto_scrip/main/cf.sh && chmod +x cf.sh && ./cf.sh ;;
#25) clear ; del-xrays ;;
#30) clear ; user-xrays ;;
0) clear ; menu ;;
x) exit ;;
*) echo -e "" ; echo "Press any key to back exit" ; sleep 1 ; exit ;;
esac
