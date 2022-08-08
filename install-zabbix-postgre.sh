#!/bin/bash
DB_USER="zabbix"
DB_PASS="zabbix"

echo ""
echo " === DOWNLOAD PACKAGE FROM ZABBIX REPOSITORY === "
echo ""
wget https://repo.zabbix.com/zabbix/6.2/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.2-1+ubuntu20.04_all.deb

echo ""
echo " === INSTALLING === "
echo ""
dpkg -i zabbix-release_6.2-1+ubuntu20.04_all.deb

echo ""
echo " === INSTALL ZABBIX WITH MYSQL === "
echo ""
apt update
apt install postgresql postgresql-contrib zabbix-server-pgsql zabbix-frontend-php php7.4-pgsql zabbix-apache-conf zabbix-sql-scripts zabbix-agent -y

echo ""
echo " === CREATE ZABBIX DATABASE === "
echo ""

sudo -u postgres createuser --pwprompt zabbix
sudo -u postgres createdb -O zabbix -E Unicode -T template0 zabbix

echo ""
echo " === IMPORT SCHEMA SQL === "
echo ""

zcat /usr/share/doc/zabbix-sql-scripts/postgresql/server.sql.gz | sudo -u zabbix psql zabbix

echo ""
echo " === ENABLE SERVICE ZABBIX SERVER AGENT AND APACHE === "
echo ""
systemctl enable zabbix-server zabbix-agent apache2


echo ""
echo " === COPYING ZABBIX SERVER CONFIGURATION === "
echo ""
cp --remove-destination zabbix_server.conf /etc/zabbix/

echo ""
echo " === RESTART SERVICE ZABBIX SERVER AGENT AND APACHE === "
echo ""
systemctl restart zabbix-server zabbix-agent apache2


echo ""
echo " OPEN BROWSER http://your_ip/zabbix "
echo ""
