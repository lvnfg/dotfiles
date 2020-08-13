#!/bin/bash

# common setup for all GNU debian linux VMs

echo Installing tmux
sudo apt install -y tmux

echo Installing git
sudo apt install -y git
git config --global credential.helper cache 3600
git config --global core.editor "vim"
git config --global user.name "van"
git config --global user.email "-"
# git clone https://github.com/lvnfg/dotfiles

# set case-insensitive autocomplettion
echo set completion-ignore-case on | sudo tee -a /etc/inputrc

echo Creating dotfies simlinks
ln -s ~/dotfiles/.vimrc         ~/.vimrc
ln -s ~/dotfiles/.tmux.conf 	~/.tmux.conf
ln -s ~/dotfiles/.ssh/config    ~/.ssh/config
rm ~/.bashrc
ln -s ~/dotfiles/.bashrc		~/.bashrc
source ~/.bashrc

echo Cloning vim github repo
git clone https://github.com/vim/vim.git ~/vim
echo Building vim from source
cd ~/vim/src
sudo apt install -y libncurses5-dev
make distclean  # clear previous install
make
sudo make install
echo Purging pre-installed vim
sudo apt purge -y vim
echo Moving vim to path
sudo mv ~/vim/src/vim /usr/bin
echo Cleaning up
sudo rm -rf ~/vim
sudo apt autoremove
echo Vim install done

echo Cloning .vim plugins
mkdir -p ~/.vim/pack/bundle/start
cd ~/.vim/pack/bundle/start
git clone https://github.com/airblade/vim-gitgutter

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

echo Remember to init gcloud if this is the first time run
# gcloud init
