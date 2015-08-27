#!/bin/bash

VOLUME_HOME="/var/lib/mysql/"

  RET=1
  while [[ RET -ne 0 ]]; do
    sleep 20
    RET=$?
  done

if [ ! -e ${VOLUME_HOME}/ibdata1 ]; then
    echo " -> Installation detected in $VOLUME_HOME"
    echo " -> Installing MariaDB"
    mysql_install_db > /dev/null 2>&1
    chown mysql.mysql -R ${VOLUME_HOME}
    /setup.sh
    echo " -> Done!"
else  
    echo "-> Booting on existing volume!"
fi

exec mysqld_safe
