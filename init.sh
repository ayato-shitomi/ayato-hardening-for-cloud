#!/bin/bash

# USERS

# 許可されたユーザーリスト
ALLOWED_USERS=(
  "root" "daemon" "bin" "sys" "sync" "games" "man" "lp" "mail" "news" "uucp"
  "proxy" "www-data" "backup" "list" "irc" "_apt" "nobody" "systemd-network"
  "systemd-timesync" "messagebus" "syslog" "systemd-resolve" "uuidd" "sshd"
  "tcpdump" "landscape" "fwupd-refresh" "polkitd" "ec2-instance-connect"
  "_chrony" "ubuntu"
)

# 現在のシステム上のユーザーを取得
CURRENT_USERS=$(cut -d: -f1 /etc/passwd)

# 不要なユーザーを削除
for user in $CURRENT_USERS; do
  if [[ ! " ${ALLOWED_USERS[@]} " =~ " ${user} " ]]; then
    echo "削除対象ユーザー: $user"
    sudo userdel -r "$user"
  fi
done

for i in {1..11} ; do useradd -m "user${i}"; done
useradd dev
useradd hardening
for i in {1..10} ; do echo "user${i}:user${i}" | chpasswd ; done
echo "root:root" | chpasswd
echo "dev:devpass123" | chpasswd
echo "user11:pass" | chpasswd

# vsftpd

# apt-get install build-essential
# useradd nobody
# mkdir /usr/share/empty
# cd ./blue-team/vsftpd-2.3.4-infected
# cp vsftpd /usr/local/sbin/vsftpd
# cp vsftpd.8 /usr/local/man/man8
# cp vsftpd.conf.5 /usr/local/man/man5
# cp vsftpd.conf /etc
# mkdir /var/ftp/
# useradd -d /var/ftp ftp
# chown root:root /var/ftp
# chmod og-w /var/ftp
# cp ./ftpd.service /etc/systemd/system/
# /usr/local/sbin/vsftpd /etc/vsftpd.conf &>/dev/null &
# 
# # FLASK
# 
# cp -r /blue-team/webapp /var/www/html/webapp
# python3 /var/www/html/webapp/app.py &
# 
# # Apache
# 
# cp /blue-team/webapp/README.md /var/www/html
# cp /blue-team/ports.conf /etc/apache2/ports.conf
# apachectl start
# 
# # SSH
# 
# mkdir /var/run/sshd
# sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
# sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
# /usr/sbin/sshd -D &
# 
# tail -f /dev/null
# 
