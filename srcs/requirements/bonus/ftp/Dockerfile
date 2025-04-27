FROM debian:bullseye

RUN apt-get update -y && apt-get install -y vsftpd
RUN mkdir -p /var/run/vsftpd/empty

COPY conf/vsftpd.conf /etc/vsftpd.conf

COPY tools/setup_ftp.sh /usr/local/bin/setup_ftp.sh
RUN chmod +x /usr/local/bin/setup_ftp.sh

CMD ["setup_ftp.sh"]
