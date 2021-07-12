#!/bin/bash
DB_USER="zabbix"
DB_PASS="zabbix"


#echo "download zabbix.deb"
#wget https://repo.zabbix.com/zabbix/5.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_5.4-1+ubuntu20.04_all.deb
#echo "installing zabbix.deb"
#dpkg -i zabbix-release_5.4-1+ubuntu20.04_all.deb
#echo "update and install"
#apt update
#apt install zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent mysql-server -y

echo "login and create database zabbix"

#mysql
mysql -e "create database zabbix character set utf8 collate utf8_bin;"
mysql -e "create user zabbix@localhost identified by 'zabbix';"
mysql -e "grant all privileges on zabbix.* to zabbix@localhost;"

#create database zabbix character set utf8 collate utf8_bin;
#create user zabbix@localhost identified by 'zabbix';
#grant all privileges on zabbix.* to zabbix@localhost;

echo "import schema sql"
zcat /usr/share/doc/zabbix-sql-scripts/mysql/create.sql.gz | mysql -uzabbix -p${DB_PASS} zabbix

systemctl restart zabbix-server zabbix-agent apache2
systemctl enable zabbix-server zabbix-agent apache2

