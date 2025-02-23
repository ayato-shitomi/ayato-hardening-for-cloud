#!/bin/bash

# ユーザーの初期化

authorized_users=("root" "ubuntu")
users=$(awk -F: '$7 ~ /\/bin\/bash|\/bin\/sh/ {print $1}' /etc/passwd)
for user in $users; do
    if [[ ! " ${authorized_users[@]} " =~ " $user " ]]; then
        echo "Deleting user: $user"
        sudo userdel -r "$user"
    fi
done

# ユーザーの追加

for i in {1..11} ; do sudo useradd -m "user${i}"; done
sudo useradd dev
for i in {1..10} ; do echo "user${i}:user${i}" | sudo chpasswd ; done
echo "root:root" | sudo chpasswd
echo "dev:devpass123" | sudo chpasswd
echo "user11:pass" | sudo chpasswd

# vsftpdの初期化

sudo apt update
sudo apt install -y build-essential
sudo userdel -r nobody
sudo useradd nobody
sudo mkdir /usr/share/empty
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
