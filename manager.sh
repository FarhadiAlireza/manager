#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
GRAY='\033[0;37m'
NC='\033[0m'

if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root"
    sleep .5
    exit 1
fi

apt update && apt upgrade -y

read_input() {
    read -p "$1: " input
    if [ -z "$input" ]; then
        echo ""
        exit 1
    fi
    echo "$input"
}

echo "Running as root..."
echo "Let's Go..."
sleep 0.8
clear

echo -e "                                       "
echo -e "${RED}█▓▒▒░░░ Hey, What do You want? ░░░▒▒▓█ "
echo -e "                                       "
echo -e "                                       "
echo -e "${RED}1) ${YELLOW}Change UUID"
echo -e "                                       "
echo -e "${RED}2) ${YELLOW}Get SLL/CA"
echo -e "                                       "
echo -e "${RED}3) ${YELLOW}Install Xray"
echo -e "                                       "
echo -e "${RED}4) ${YELLOW}Update Ubuntu kernel"
echo -e "                                       "
echo -e "${RED}5) ${YELLOW}Install BBR"
echo -e "                                       "
echo -e "${RED}6) ${YELLOW}Install WARP"
echo -e "                                       "
echo -e "${RED}7) ${YELLOW}Change SSH port"
echo -e "                                       "
echo -e "${RED}8) ${YELLOW}Download Raw Xray Config "
echo -e "                                       "
echo -e "${RED}9) ${YELLOW}Install Hysteria script"
echo -e "                                       "
echo -e "${RED}10) ${YELLOW}Install Sing-box-Reality script"
echo -e "                                       "
echo -e "${RED}11) ${YELLOW}Install Tuic script"
echo -e "                                       "
echo -e "${RED}12) ${YELLOW}Install all Geo files "
echo -e "                                       "
echo -e "${RED}13) ${YELLOW}Enable HTTPS for Domain [Nginx] "
echo -e "                                       "
echo -e "${RED}14) ${YELLOW}Make usable configs for V2ray"
echo -e "                                       "
read -p "Enter option number: " choice

case $choice in
  1)
    wget https://raw.githubusercontent.com/FarhadiAlireza/ChangingUUID/main/ch-uuid.py
    python3 ch-uuid.py
;;
  2)
      mkdir "certs"
      openssl ecparam -genkey -name prime256v1 -out /root/certs/key.key
      openssl req -new -x509 -days 36500 -key /root/certs/key.key -out /root/certs/key.crt  -subj "/CN=bing.com"
;;
  3)
    echo -e "1) Pre-release Version "
    echo -e "2) Stable Version "
    echo -e "3) Remove Xray, include json and logs"
    echo -e "4)Remove Xray, except json and logs "
    read -p "Enter the options: " xrayVersion
    case $xrayVersion in
    1)
      bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install --beta -u root
      ;;
    2)
      bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install -u root
      ;;
    3)
      bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ remove --purge
      ;;
    4)
      bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ remove
    esac
    ;;
  4)
    wget https://raw.githubusercontent.com/pimlie/ubuntu-mainline-kernel.sh/master/ubuntu-mainline-kernel.sh &&
    install ubuntu-mainline-kernel.sh /usr/local/bin/
    echo -e "https://kernel.ubuntu.com/~kernel-ppa/mainline/"
   ;;
 5)
   wget https://raw.githubusercontent.com/teddysun/across/master/bbr.sh
   exit 1
   uname -r
   echo -e ""
   sysctl net.ipv4.tcp_available_congestion_control
   echo -e "The return value is generally: [net.ipv4.tcp_available_congestion_control = bbr cubic reno] OR [net.ipv4.tcp_available_congestion_control = reno cubic bbr]"
   echo -e ""
   sysctl net.ipv4.tcp_congestion_control
   echo -e "The return value is generally: [net.ipv4.tcp_congestion_control = bbr]"
   echo -e ""
   sysctl net.core.default_qdisc
   echo -e "The return value is generally: [net.core.default_qdisc = fq]"
   echo -e ""
   lsmod | grep bbr
   echo -e "INSTALLING SUCCESSFULLY"
  ;;
 6)
   bash <(wget -qO- https://gitlab.com/rwkgyg/CFwarp/raw/main/CFwarp.sh 2> /dev/null)
  ;;
 7)
   read -p "Enter new port: " newPort
    sed -i 's/^#Port 22/Port '"$newPort"'/' /etc/ssh/sshd_config
  ;;
8)
  if [ ! -f "rawXrayConfig.json" ]; then
  	wget https://raw.githubusercontent.com/FarhadiAlireza/xrayRawConfig/main/rawConfig.json
    echo 'The "rawXrayConfig.json" file has been created!'
    clear
  elif [ -f "rawXrayConfig.json" ]; then
    echo -e 'The "rawXrayConfig.json" file exists!\n'
    sleep 1
  fi
 ;;
9)
  echo -e "Installing Hysteria script"
  echo -e "https://v2.hysteria.network/docs/getting-started/Installation/"
  echo -e "https://telegra.ph/How-run-Hysteria-V2-Protocol-with-iSegaro-09-02"
 ;;
10)
  bash <(curl -fsSL https://github.com/deathline94/sing-REALITY-Box/raw/main/sing-REALITY-box.sh)
 ;;
11)
  echo -e "Installation Tuic script"
  echo -e "https://github.com/EAimTY/tuic/tree/dev/tuic-server"
  echo -e "https://telegra.ph/How-to-start-the-TUIC-v5-protocol-with-iSegaro-08-26"
 ;;
12)
  cd /usr/local/x-ui/bin
  wget https://github.com/bootmortis/iran-hosted-domains/releases/latest/download/iran.dat
  wget https://github.com/v2fly/domain-list-community/releases/latest/download/dlc.dat
  wget https://github.com/v2fly/geoip/releases/latest/download/geoip.dat
 ;;
13)
  read -p "Use Apache2 OR Use Nginx? (a/n)" webServer
  if [ "$webServer" == "a" ]; then
    read -p "Please enter your Domain: " domain
    read -p "Please enter your Email: " email
    apt install apache2 apache2-doc apache2-utils
    systemctl status apache2
    a2dissite 000-default.conf
    systemctl reload apache2
    ufw disable
    mkdir /var/www/html/"$domain"
    mkdir /var/www/html/"$domain"/public_html
    mkdir /var/www/html/"$domain"/backups
    touch /etc/apache2/sites-available/"$domain".conf
     str=$(cat <<EOF
      <VirtualHost *:80>
          ServerAdmin "$email"
          ServerName "$domain"
          ServerAlias www."$domain"
          DocumentRoot /var/www/html/"$domain"/public_html/
          ErrorLog /var/www/html/"$domain"/logs/error.log
          CustomLog /var/www/html/"$domain"/logs/access.log combined
      </VirtualHost>
EOF
         )
   echo "$str" > "$domain".conf
   a2ensite "$domain"
   systemctl reload apache2
   apt install certbot python3-certbot-apache
   certbot --apache -d "$domain"

elif [ "$webServer" == "n" ]; then
    read -p "Please enter your Domain: " domain
    apt install nginx nginx-doc
    systemctl reload nginx
    systemctl status nginx
    ufw disable
    mkdir /var/www/html/"$domain"
    mkdir /var/www/html/"$domain"/public_html
    mkdir /var/www/html/"$domain"/backups
    touch /etc/nginx/sites-available/"$domain".conf
    apt install certbot python3-certbot-nginx
    certbot --nginx -d "$domain"
     str=$(cat <<EOF
server {
    server_name "$domain";
    root /var/www/html/"$domain"/public_html;
    access_log /var/www/html/"$domain"/logs/access.log;
    error_log /var/www/html/"$domain"/logs/error.log;

    location / {
        # Your Nginx location directives go here if needed.
        # For example, you can use try_files to handle URLs.
        # Example: try_files $uri $uri/ /index.php;
    }
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php7.4-fpm.sock; # Adjust to your PHP-FPM socket path.
    }
    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/"$domain"/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/"$domain"/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot
}
server {
    if ($host = "$domain") {
        return 301 https://$host$request_uri;
    } # managed by Certbot
    listen 80;
    server_name "$domain";
    return 404; # managed by Certbot
}
EOF
  )
   echo "$str" > "$domain".conf
   nginx -t
   systemctl reload nginx
   ln -s /etc/nginx/sites-available/"$domain" /etc/nginx/sites-enabled/
   nginx -t
   systemctl reload nginx
  fi
 ;;
14)
    wget https://raw.githubusercontent.com/FarhadiAlireza/Making-UsableConfigs/main/mk-configs.py
    python3 mk-configs.py
 ;;
esac
