// install samba
sudo apt install samba

// edit the samba config file 
sudo nano /etc/samba/smb.conf

//Add this to end of file for each folder you want to share
[share-name]
    comment = write a comment about the share
    path = /path/to/the/folder/you/want/to/share
    read only = no
    browsable = yes

// restart the samba service
sudo service smbd restart

// allow samba through the firewall
sudo ufw allow samba

//add user and password to samba
sudo smbpasswd -a david
