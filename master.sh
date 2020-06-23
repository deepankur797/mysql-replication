mysqlpass=$1
slavepass=$2
slaveip=$3
sudo yum install sshpass -y
sleep 5
cp /etc/my.cnf /etc/my.cnf.bkp
sed -i '/\[mysqld\]/r master.txt' /etc/my.cnf
systemctl restart mysqld

sleep 10
mysql -uroot -pAdmin987! -Bse "uninstall plugin validate_password;"
mysql -u root -p$mysqlpass -Bse "GRANT REPLICATION SLAVE ON *.* TO 'slave_user'@'%' IDENTIFIED BY ""'\'$slavepass\'';"
mysql -u root -p$mysqlpass -Bse "FLUSH PRIVILEGES;"
mysql -u root -p$mysqlpass -Bse "FLUSH TABLES WITH READ LOCK;"
mysql -u root -p$mysqlpass -Bse "SHOW MASTER STATUS;"


file=$(mysql -u root -p$mysqlpass -Bse "SHOW MASTER STATUS;" | awk '{print $1}')
pos=$(mysql -u root -p$mysqlpass -Bse "SHOW MASTER STATUS;" | awk '{print $2}')

echo $file >>param.txt
echo $pos >>param.txt
mysqldump -u root -p$mysqlpass --all-databases --master-data > /root/dbdump.db

mysql -u root -p$mysqlpass -Bse "UNLOCK TABLES;"
sshpass -p '@________!' scp /root/dbdump.db root@$slaveip:/root/


firewall-cmd --zone=public --add-port=3306/tcp --permanent
firewall-cmd --reload
iptables-save | grep 3306
