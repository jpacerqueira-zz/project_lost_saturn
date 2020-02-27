#!/usr/bin/env bash -xe
sudo apt-get update -y && apt-get install -y \
     openssh-client \
     openssh-server \
     nginx
sudo systemctl stop ssh
sudo systemctl start ssh
sudo systemctl reload ssh
sudo systemctl status ssh
########
sudo echo '# try_files $uri $uri/ =404;' >> /etc/nginx/sites-available/default
sudo echo 'proxy_pass http://127.0.0.1:54321;' >> /etc/nginx/sites-available/default
#
mkdir -p /home/notebookuser/.ssh/
sudo rm -f /home/notebookuser/.ssh/thekey.pem 
touch /home/notebookuser/.ssh/thekey.pem
echo '/home/notebookuser/.ssh/thekey.pem' | ssh-keygen
chmod 400 /home/notebookuser/.ssh/thekey.pem
sudo service nginx restart
ssh -i /home/notebookuser/.ssh/thekey.pem -R 9004:127.0.0.1:54321 -p 9004 notebookuser@127.0.0.1 #$(hostname -I | cut -d' ' -f1)
########
