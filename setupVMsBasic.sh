#!/bin/bash

# common setup for all GNU debian linux VMs

echo Installing tmux
sudo apt install -y tmux

echo Installing git
sudo apt install -y git
git config --global credential.helper cache 3600
git config --global core.editor "vim"
git config --global core.user "van"
git config --global core.email "-"
git clone https:/lvnfg@github.com/lvnfg/dotfiles

# set case-insensitive autocomplettion
echo set completion-ignore-case on | sudo tee -a /etc/inputrc

echo Creating dotfies simlinks
ln -s ~/dotfiles/.vimrc         ~/.vimrc
ln -s ~/dotfiles/.vim           ~/.vim
ln -s ~/dotfiles/.tmux.conf 	~/.tmux.conf
ln -s ~/dotfiles/.ssh/config    ~/.ssh/config
rm ~/.bashrc
ln -s ~/dotfiles/.bashrc		~/.bashrc
source ~/.bashrc

echo Remember to disable all ssh password login, including root
# sudo vim /etc/ssh/sshd_config
# change the following lines to no 
#   ChallengeResponseAuthentication no
#   PasswordAuthentication no
#   UsePAM no
#   PermitRootLogin no
# sudo systemctl restart ssh

echo Remember to generate ssh key if needed
# ssh-keygen -t rsa -b 4096 -C "van@vm-"
