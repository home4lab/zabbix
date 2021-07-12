#!/bin/bash

wget https://repo.zabbix.com/zabbix/5.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_5.4-1+ubuntu20.04_all.deb
dpkg -i zabbix-release_5.4-1+ubuntu20.04_all.deb
apt update
apt install zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent mysql-server



mysql -uroot -p
#mysql --defaults-extra-file=sql.cnf -e "create database zabbix character set utf8 collate utf8_bin;"
#mysql --defaults-extra-file=sql.cnf -e "create user zabbix@localhost identified by 'zabbix';"
#mysql --defaults-extra-file=sql.cnf -e "grant all privileges on zabbix.* to zabbix@localhost;"

create database zabbix character set utf8 collate utf8_bin;
create user zabbix@localhost identified by 'zabbix';
grant all privileges on zabbix.* to zabbix@localhost;

zcat /usr/share/doc/zabbix-sql-scripts/mysql/create.sql.gz | mysql -uzabbix -p zabbix
