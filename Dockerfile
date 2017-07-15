# written by Benoit Sarda
# MariaDB database, on a centos 7. does not support cluster
#
#   bsarda <b.sarda@free.fr>
#
#FROM centos:centos7.2.1511
FROM centos:7
LABEL maintainer "b.sarda@free.fr"

# expose
EXPOSE 3306

# declare vars
ARG MARIADB_VERSION=10.1
ENV DB_DATADIR=/var/lib/mysql/data \
	DB_ADMINUSER=mariadb \
	DB_ADMINPASS=maria

# add files
ADD [	"mariadb.repo", \
	"init.sh", \
	"stop.sh", \
	"/tmp/"]

# install prereq
RUN rpm --import https://yum.mariadb.org/RPM-GPG-KEY-MariaDB && \
	yum install -y net-tools && \
	mv /tmp/mariadb.repo /etc/yum.repos.d/ && mv /tmp/init.sh /usr/local/bin/init.sh && mv /tmp/stop.sh /usr/local/bin/stop.sh && \
	sed -i "s@10.1@$MARIADB_VERSION@" /etc/yum.repos.d/mariadb.repo && cat /etc/yum.repos.d/mariadb.repo | grep baseurl

RUN chmod 750 /usr/local/bin/init.sh && chmod 750 /usr/local/bin/stop.sh && \
	# install database
	yum install -y MariaDB-server MariaDB-client && \
	mkdir -p $DB_DATADIR && \
	sed -i 's@#bind-address=.*@bind-address=0.0.0.0@gi' /etc/my.cnf.d/server.cnf && \
	sed -i 's@\[mysqld\]@\[mysqld\]\nskip-host-cache\nskip-name-resolve@gi' /etc/my.cnf.d/server.cnf

# create the volume
VOLUME /var/lib/mysql

CMD ["/usr/local/bin/init.sh"]
