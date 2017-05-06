#!/bin/bash

## PRESTASHOP TOOLS ##
## By Vincent G
######


# Download Presta
function downloadAllPrestashop {
  END=13
  for i in $(seq 0 $END); do
    URL='https://download.prestashop.com/download/old/prestashop_1.6.1.'$i'.zip'
    echo "# DOWNLOADING : " $URL
    wget $URL

  done
}

#unzip all prestashop
function unzipPrestashop {

  for file in prestashop_1.6.1.*.zip
  do
    unzip $file -d ${file%.zip}
  done

}

# Install VHOST
function createNgVhost {

  echo " QUEL EST LE NOM DU DOMAINE ? (exemple.fr)"
  read domain

  for file in prestashop_1.6.1.*.zip
  do

    # Create vhost
    domainFinal=${file%.zip}.$domain
    echo "Create vhost : " $domainFinal.conf
    sed s/prestashop.domain.tld/$domainFinal/g ng-default-config.conf > $domainFinal.conf

    # Move prestashop folder into webserver root
    mkdir /var/www/$domainFinal
    mv ${file%.zip}/prestashop/* /var/www/$domainFinal/

    # RM existing vhost
    #rm /etc/nginx/sites-available/$domainFinal.conf
    #rm /etc/nginx/sites-enabled/$domainFinal.conf

    # Copie into /etc/nginx/sites-available
    echo "Copy vhost to /etc/nginx/sites-available/ "
    cp -f $domainFinal.conf /etc/nginx/sites-available/

    echo "Activate website"
    ln -s /etc/nginx/sites-available/$domainFinal.conf /etc/nginx/sites-enabled/$domainFinal.conf

    echo "Restat nginx"
    service nginx restart

    echo "Chmod www-data"
    chown -R www-data:www-data /var/www/$domainFinal/

  done

}


# User choice :
echo " QUEL CHOIX ?"
echo "1 - DOWNLOAD ALL VERSION "
echo "2 - UNZIP ALL VERSION "
echo "3 - INSTALL VHOST"
read reponse;

case "$reponse" in
    "1")
        downloadAllPrestashop
        ;;
    "2")
        unzipPrestashop
        ;;
    "3")
        createNgVhost
        ;;
esac
