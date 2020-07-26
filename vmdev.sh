#!/bin/bash

# starting up
sudo apt update && sudo apt upgrade
sudo update-alternatives --config editor # 2
sudo apt install tmux
ssh-keygen -t rsa -b 4096 -C "van@vmdev"    # generate a new key pair
sudo apt install git    # remember to copy ssh key to github
git clone git@github.com:lvnfg/dotfiles.git     ~/repos/dotfiles
git config --global core.editor "vim"
git config --global user.name "van"
git config --global user.email "-"
rm ~/.bashrc && ln -s ~/repos/dotfiles/.bashrc ~/.bashrc && source .bashrc
# disable ssh password login, including root
sudo vim /etc/ssh/sshd_config
    # change the following lines to no 
    #   ChallengeResponseAuthentication no
    #   PasswordAuthentication no
    #   UsePAM no
    #   PermitRootLogin no
sudo systemctl restart ssh

# development tools
sudo apt install postgresql-client
# desktop environment, if necessary
sudo apt install lxde
sudo apt install xrdp
sudo systemctl status xrdp  # verify xrdp is running
sudo vim /etc/xrdp/startwm.sh   # add to end of file: lxsession -s LXDE -e LXDE
sudo service xrdp restart
sudo systemctl set-default multi-user.target    # disable GUI on boot. Use graphical.target to reenable
sudo passwd van # set user password to connect over xrdp if none existing
