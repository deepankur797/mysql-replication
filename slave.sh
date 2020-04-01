mysqlpass=$1
slavepass=$2
masterhost=$3
file=$4
pos=$5
sed -i '/\[mysqld\]/r slave.txt' /etc/my.cnf

sudo systemctl restart mysqld
mysql -uroot -pAdmin987! -Bse "uninstall plugin validate_password;"
mysql -u root -p$mysqlpass < /root/dbdump.db
mysql -u root -p$mysqlpass -Bse "stop slave;"
mysql -u root -p$mysqlpass -Bse "CHANGE MASTER TO MASTER_HOST='$masterhost', MASTER_USER='slave_user', MASTER_PASSWORD='$slavepass', MASTER_LOG_FILE='$file', MASTER_LOG_POS=$pos;"

mysql -u root -p$mysqlpass -Bse "start slave;"
