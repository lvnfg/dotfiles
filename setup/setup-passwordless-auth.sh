#!/bin/bash

# Disable password login. This should be default on Azure VM Debian 10 Gen 1 image.

sudo vim /etc/ssh/sshd_config
echo "
To disable password authenticaion, run:
sudo vim /etc/ssh/sshd_config           
Then edit the following:
    PubkeyAuthentication yes            # Default commented out. Important, will not be able to log back in if not enabled
    UsePAM yes                          # Default. May disable pubkey authen if set to no, keep yes for the moment
    PasswordAuthentication no           # Default
    PermitEmptyPasswords no             # Default 
    PermitRootLogin no                  # Not found in Azure Debian 10 Gen 1 image's sshd
    ChallengeResponseAuthentication no  
sudo service sshd restart
All this should be default on Azure VM Debian 10 Gen 1 image.
"
