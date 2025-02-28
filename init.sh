#!/bin/bash

# 必要なアプリのインストール

sudo apt update
sudo apt install -y build-essential
sudo apt install -y python3-pip
pip3 install flask
sudo apt install -y apache2

# ユーザーの初期化

authorized_users=("root" "ubuntu" "hardening")
users=$(awk -F: '$7 ~ /\/bin\/bash|\/bin\/sh/ {print $1}' /etc/passwd)
for user in $users; do
    if [[ ! " ${authorized_users[@]} " =~ " $user " ]]; then
        echo "Deleting user: $user"
        sudo userdel -r "$user"
    fi
done

# ユーザーディレクトリの初期化

for i in {1..11} ; do sudo rm -rf /home/"user${i}"; done
rm -rf /home/dev
find /root -mindepth 1 ! -path /root/snap -exec rm -rf {} +
# ubuntu

# ユーザーの追加

for i in {1..11} ; do sudo useradd -m "user${i}"; done
sudo useradd -m dev
for i in {1..10} ; do echo "user${i}:user${i}" | sudo chpasswd ; done
echo "root:root" | sudo chpasswd
echo "dev:devpass123" | sudo chpasswd
echo "user11:pass" | sudo chpasswd
echo "hardening:hardening" | sudo chpasswd

# UFW の初期化

echo y | sudo ufw reset
echo y | sudo ufw disable

# vsftpdの初期化

sudo systemctl stop ftpd
sudo userdel -r nobody
sudo useradd nobody
sudo mkdir /usr/share/empty
sudo curl -o /usr/local/sbin/vsftpd https://raw.githubusercontent.com/ayato-shitomi/ayato-hardening-for-cloud/main/src/vsftpd/vsftpd 
sudo curl -o /usr/local/man/man8 https://raw.githubusercontent.com/ayato-shitomi/ayato-hardening-for-cloud/main/src/vsftpd/vsftpd.8
sudo curl -o /usr/local/man/man5 https://raw.githubusercontent.com/ayato-shitomi/ayato-hardening-for-cloud/main/src/vsftpd/vsftpd.conf.5
sudo curl -o /etc/vsftpd.conf https://raw.githubusercontent.com/ayato-shitomi/ayato-hardening-for-cloud/main/src/vsftpd/vsftpd.conf
sudo curl -o /etc/systemd/system/ftpd.service https://raw.githubusercontent.com/ayato-shitomi/ayato-hardening-for-cloud/main/src/vsftpd/ftpd.service
sudo rm -rf /var/ftp/
sudo mkdir /var/ftp/
sudo useradd -d /var/ftp ftp
sudo chmod +x /usr/local/sbin/vsftpd
sudo chmod og-w /var/ftp
sudo chown root:root /var/ftp
sudo chown root:root /usr/local/sbin/vsftpd
sudo chown root:root /usr/local/man/man8
sudo chown root:root /usr/local/man/man5
sudo chown root:root /etc/vsftpd.conf
sudo systemctl enable ftpd
sudo systemctl start ftpd

# FLASKの初期化

sudo systemctl stop http-flask
sudo systemctl daemon-reload
sudo rm -rf /var/www
sudo mkdir /var/www
sudo mkdir /var/www/html
sudo mkdir /var/www/html/webapp
sudo mkdir /var/www/html/webapp/static
sudo mkdir /var/www/html/webapp/static/css
sudo mkdir /var/www/html/webapp/templates
sudo curl -o /var/www/html/webapp/app.py https://raw.githubusercontent.com/ayato-shitomi/ayato-hardening-for-cloud/main/src/webapp/app.py
sudo curl -o /var/www/html/webapp/static/css/style.css https://raw.githubusercontent.com/ayato-shitomi/ayato-hardening-for-cloud/main/src/webapp/static/css/style.css
sudo curl -o /var/www/html/webapp/templates/index.html https://raw.githubusercontent.com/ayato-shitomi/ayato-hardening-for-cloud/main/src/webapp/templates/index.html
sudo curl -o /etc/systemd/system/http-flask.service https://raw.githubusercontent.com/ayato-shitomi/ayato-hardening-for-cloud/main/src/webapp/http-flask.service
sudo systemctl enable http-flask
sudo systemctl start http-flask

# Apache

sudo curl -o /var/www/html/README.md https://raw.githubusercontent.com/ayato-shitomi/ayato-hardening-for-cloud/main/src/web/README.md
sudo curl -o /var/www/html/index.html https://raw.githubusercontent.com/ayato-shitomi/ayato-hardening-for-cloud/main/src/web/index.html
sudo curl -o /etc/apache2/ports.conf https://raw.githubusercontent.com/ayato-shitomi/ayato-hardening-for-cloud/main/src/web/ports.conf
sudo systemctl enable apache2
sudo systemctl start apache2

# SSH
sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo sed -i 's/^#\?PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo systemctl restart ssh

