FROM oraclelinux:7-slim

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -g 1010  -r mysql && useradd -u 1010 -r -g mysql mysql

#FROM oraclelinux:7-slim
ENV PACKAGE_URL https://repo.mysql.com/yum/mysql-5.7-community/docker/x86_64/mysql-community-server-minimal-5.7.18-1.el7.x86_64.rpm

# Install server
RUN rpmkeys --import http://repo.mysql.com/RPM-GPG-KEY-mysql \
  && yum install -y $PACKAGE_URL \
  && yum install -y libpwquality \
  && rm -rf /var/cache/yum/*
RUN mkdir /docker-entrypoint-initdb.d

VOLUME /var/lib/mysql

COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 3306 33060
CMD ["mysqld"]
