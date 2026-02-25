#!/bin/bash


if [ "$EUID" -ne 0 ]; then
  echo "you are not sudo user.please run this script agian with sudo"
  exit 1
fi

echo "=========================================="
echo "   Certbot Standalone Auto-Installer"
echo "=========================================="


if ! command -v certbot &> /dev/null; then
    echo "installing certbot ...."
    apt-get update
    apt-get install -y certbot
    echo "certbot installed sucessfully."
else
    echo "certbot is already installed."
fi

echo "------------------------------------------"
echo "please make sure port 80 is available"
echo "please down all your containers"
read -p "port 80 is available? (y/n): " PORT_CHECK

if [[ "$PORT_CHECK" != "y" && "$PORT_CHECK" != "Y" ]]; then
    echo "make sure port 80 is up and avialable."
    exit 1
fi

echo "------------------------------------------"

read -p "please enter your valid email address for installing certbot " EMAIL


echo "please seprate all domains and sub-domains with space."
echo "example: dev.example.com org.example.com panel.example.com"
read -p "enter your domain and sub-domains:  " DOMAIN_INPUT


DOMAIN_ARGS=""
for DOMAIN in $DOMAIN_INPUT; do
    DOMAIN_ARGS="$DOMAIN_ARGS -d $DOMAIN"
done

echo "------------------------------------------"
echo "please wait...."
echo "requested domains: $DOMAIN_INPUT"
echo "------------------------------------------"


certbot certonly --standalone \
  --preferred-challenges http \
  --non-interactive \
  --agree-tos \
  --email "$EMAIL" \
  $DOMAIN_ARGS


if [ $? -eq 0 ]; then
    echo "=========================================="
    echo "all ssl cert installed sucessfully."
    echo "ssl path: /etc/letsencrypt/live/"
    echo "=========================================="
else
    echo "check your domain name and internet connection and try agian."
fi
