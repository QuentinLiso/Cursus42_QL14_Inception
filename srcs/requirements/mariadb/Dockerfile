FROM debian:bullseye

RUN apt-get update -y && apt-get upgrade -y && apt-get install -y mariadb-server

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/.

RUN mkdir /run/mysqld && chown mysql:mysql /run/mysqld

COPY tools/setup_mdb.sh /usr/local/bin/setup_mdb.sh
RUN chmod +x /usr/local/bin/setup_mdb.sh

EXPOSE 3306

CMD ["setup_mdb.sh"]
