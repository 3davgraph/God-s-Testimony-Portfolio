#!/bin/bash

# Prompt for username
read -p "Enter new username: " USERNAME

# Check if user already exists
if id "$USERNAME" &>/dev/null; then
    echo "User '$USERNAME' already exists."
    exit 1
fi

# Create user with home dir, bash shell, and add to sudo group
useradd -m -s /bin/bash -G sudo "$USERNAME"

# Set password
echo "Set password for $USERNAME:"
passwd "$USERNAME"

# Copy default and root environment configs
cp /etc/skel/.bashrc /home/"$USERNAME"/
cp /etc/skel/.profile /home/"$USERNAME"/
cp /root/.bashrc /home/"$USERNAME"/
cp /root/.profile /home/"$USERNAME"/

# Fix ownership
chown "$USERNAME:$USERNAME" /home/"$USERNAME"/.bashrc /home/"$USERNAME"/.profile

# Optional: Add prompt config (if not already in bashrc)
grep -q 'PS1=' /home/"$USERNAME"/.bashrc || echo 'PS1="\u@\h:\w\$ "' >> /home/"$USERNAME"/.bashrc

echo "User '$USERNAME' created with sudo access and bash environment configured."
