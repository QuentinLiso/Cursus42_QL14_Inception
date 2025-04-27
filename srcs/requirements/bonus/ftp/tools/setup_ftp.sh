#!/bin/bash

useradd -m -d /var/www/html -s /bin/bash ${FTP_USER}
echo "${FTP_USER}:${FTP_PASS}" | chpasswd

vsftpd
