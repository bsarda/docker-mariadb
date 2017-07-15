#!/bin/sh
docker ps -a | grep bsarda/mariadb | awk '{print $1}' | xargs -n1 docker rm -f
docker rmi bsarda/mariadb:10.3
docker rmi bsarda/mariadb:10.2
docker rmi bsarda/mariadb:10.1
docker rmi bsarda/mariadb

sed -i 's@MARIADB_VERSION=.*@MARIADB_VERSION=10.1@' Dockerfile
docker build --build-arg MARIA_VERSION=10.1 -t bsarda/mariadb:10.1 .
sed -i 's@MARIADB_VERSION=.*@MARIADB_VERSION=10.2@' Dockerfile
docker build --build-arg MARIA_VERSION=10.2 -t bsarda/mariadb:10.2 .
sed -i 's@MARIADB_VERSION=.*@MARIADB_VERSION=10.3@' Dockerfile
docker build --build-arg MARIA_VERSION=10.3 -t bsarda/mariadb:10.3 .
docker tag bsarda/mariadb:10.3 bsarda/mariadb:latest

# back to first release
sed -i 's@MARIADB_VERSION=.*@MARIADB_VERSION=10.1@' Dockerfile
