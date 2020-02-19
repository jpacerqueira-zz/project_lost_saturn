#!/bin/bash
#
wget -q -O - https://tjend.github.io/repo_terraform/repo_terraform.key | sudo apt-key add -
sudo echo 'deb [arch=amd64] https://tjend.github.io/repo_terraform stable main' >> /etc/apt/sources.list.d/terraform.list
sudo apt-get update -y
sudo apt-get install -y terraform
#
## ONE LINE NOT RELIABLE ###
#sudo apt-get install jq
#sudo echo ; zcat <( CURRR_VER=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r -M '.current_version') ; curl -q "https://releases.hashicorp.com/terraform/${CURRR_VER#?}/terraform_${CURRR_VER#?}_linux_amd64.zip" ) | sudo tee /usr/local/bin/terraform > /dev/null ; sudo chmod +x /usr/local/bin/terraform 
#
