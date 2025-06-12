#!/bin/bash 
# this will install Docker and then Portainer. These were copied and compiled together from the offical websites.
 
# First update and install the needed files
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg lsb-release


# Next we need to add Docker's keyring
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Now we add Docker's repo to docker.list in /etc/apt/sources.list.d/
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null


# update again
sudo apt-get update

#install Docker (finally)
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

#Now we add Portainer CE (Commumity Edition) to a standalone Docker Instalation (1 Computer)
sudo docker volume create portainer_data
sudo docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest

#now visit - [IP OF COMPUTER WITH DOCKER]:9443 if accessing remotly. (Make sure port 9443 is open through the firewall)
#If accessing localy, visit - localhost:9443
