#!/bin/bash

ip addr add $ADDR/16 dev eth0

echo " -> Setting wsrep_cluster_address -> $CLUSTER_ADDR"
sed -i -r "s/#wsrep_cluster_address=gcomm:\/\//wsrep_cluster_address=gcomm:\/\/$CLUSTER_ADDR/i" /etc/my.cnf.d/server.cnf

echo "-> hostname -> $ADDR"
echo " -> Setting wsrep_node_address -> $ADDR"
sed -i -r "s/#wsrep_node_address=/wsrep_node_address=$ADDR/i" /etc/my.cnf.d/server.cnf

# $CLUSTER_ADDRが設定されていたらnode
if [ ! -z $CLUSTER_ADDR ]; then
  echo " -> I am Node"
  RET=1
  while [[ RET -ne 0 ]]; do
    sleep 20
    mysql -h $CLUSTER_ADDR -u $DB_ROUSER -p$DB_ROPASS -e "status" > /dev/null 2>&1
    RET=$?
  done
  echo " -> Found Master Server"
  exit
else
  echo "-> I am Master"
fi


echo " -> GRANT Database User"
if [ -z "$DB_RWUSER" ]; then
  echo " -> Not Found '$DB_RWUSER' -> $DB_RWUSER"
  exit
fi

/usr/bin/mysqld_safe > /dev/null 2>&1 &

RET=1  
while [[ RET -ne 0 ]]; do  
    sleep 3
    mysql -uroot -e "status" > /dev/null 2>&1
    RET=$?
done

mysql -uroot -h 127.0.0.1 -e "GRANT ALL PRIVILEGES ON *.* TO '$DB_RWUSER'@'%' IDENTIFIED BY '$DB_RWPASS' WITH GRANT OPTION"
# ROユーザー作成と同時にshutdownする
mysql -uroot -h 127.0.0.1 -e "GRANT SELECT ON *.* TO '$DB_ROUSER'@'%' IDENTIFIED BY '$DB_ROPASS'"; mysqladmin -uroot shutdown;
