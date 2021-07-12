#!/bin/bash
DB_USER="zabbix"
DB_PASS="zabbix"

echo ""
echo " === DOWNLOAD PACKAGE FROM ZABBIX REPOSITORY === "
echo ""
wget https://repo.zabbix.com/zabbix/5.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_5.4-1+ubuntu20.04_all.deb

echo ""
echo " === INSTALLING === "
echo ""
dpkg -i zabbix-release_5.4-1+ubuntu20.04_all.deb

echo ""
echo " === INSTALL ZABBIX WITH MYSQL === "
echo ""
apt update
apt install zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent mysql-server -y

echo ""
echo " === CREATE ZABBIX DATABASE === "
echo ""
mysql -e "create database zabbix character set utf8 collate utf8_bin;"
mysql -e "create user zabbix@localhost identified by 'zabbix';"
mysql -e "grant all privileges on zabbix.* to zabbix@localhost;"

echo ""
echo " === IMPORT SCHEMA SQL === "
echo ""
zcat /usr/share/doc/zabbix-sql-scripts/mysql/create.sql.gz | mysql -uzabbix -p${DB_PASS} zabbix

echo ""
echo " === ENABLE SERVICE ZABBIX SERVER AGENT AND APACHE === "
echo ""
systemctl enable zabbix-server zabbix-agent apache2


echo ""
echo " === COPYING ZABBIX SERVER CONF === "
echo ""
cp --remove-destination zabbix_server.conf /etc/zabbix/
cp --remove-destination zabbix.conf.php /usr/share/zabbix/conf/

echo ""
echo " === RESTART SERVICE ZABBIX SERVER AGENT AND APACHE === "
echo ""
systemctl restart zabbix-server zabbix-agent apache2


echo ""
echo " OPEN BROWSER http://your_ip/zabbix "
echo ""

