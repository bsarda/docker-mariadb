# docker-mariadb
This is a MariaDB container on CentOS 7.2 1511.  
Mounts a volume, with data/ for databases location.  
__Note : the admin user CANNOT be root__  

Sample usage:  
`docker run -p 43306:3306 -d --name mariadb --env DB_ADMINPASS='P@ssw0rd!' bsarda/mariadb`  
Check if it works, adding database and user:  
```
docker exec mariadb mysql -h 127.0.0.1 --user mariadb --password='P@ssw0rd!' -e "show databases;"  
docker exec mariadb mysql -h 127.0.0.1 --user mariadb --password='P@ssw0rd!' -e "create database ejbca;grant all privileges on ejbca.* to 'ejbca'@'%' identified by 'ejbca';flush privileges;"  
```

## Options as environment vars
- DB_ADMINUSER => default 'mariadb'
- DB_ADMINPASS => default 'maria'
