echo "WE'RE ABOUT TO STOP RIGHT NOW !"
# stop database
/usr/bin/mysqladmin -h127.0.0.1 --protocol=tcp shutdown

echo "Everything is properly stopped, we can exit"
# everything is properly stopped, we can exit
rm -f /tmp/letitrun
