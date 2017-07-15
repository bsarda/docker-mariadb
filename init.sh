#!/bin/bash
touch /tmp/letitrun

if [ ! -f /var/local/mariadb-initialized ]; then
    echo "This is the first launch - will init database..."
    # start mariadb
    /usr/bin/mysql_install_db -u mysql --datadir=$DB_DATADIR
    /usr/bin/mysqld_safe &
    while !(/usr/bin/mysqladmin ping)
    do
      	echo "Wating for MariaDB start up"
      	sleep 1;
    done

    # set password for account
    mysql -h localhost -u root -e "SET @@SESSION.SQL_LOG_BIN=0; CREATE USER '$DB_ADMINUSER'@'%' IDENTIFIED BY '$DB_ADMINPASS' ; GRANT ALL ON *.* TO '$DB_ADMINUSER'@'%' WITH GRANT OPTION ; DROP DATABASE IF EXISTS test ; FLUSH PRIVILEGES ;"

	  # create flag file
    touch /var/local/mariadb-initialized;
else
    echo "DB Already initialized, no need to reinit"
	  # launch mariadb
    /usr/bin/mysqld_safe &
    while !(/usr/bin/mysqladmin ping)
    do
        echo "Wating for MariaDB start up"
        sleep 1;
    done
fi

echo "DB Started !"

# wait in an infinite loop for keeping alive pid1
trap '/bin/sh -c "/usr/local/bin/stop.sh"' SIGTERM
while [ -f /tmp/letitrun ]; do sleep 1; done
exit 0;
