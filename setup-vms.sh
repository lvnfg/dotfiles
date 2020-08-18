#!/bin/bash

# common setup for all GNU debian linux VMs

echo Installing apps
sudo apt install -y tmux
sudo apt install -y fzf
sudo apt install -y git

echo Creating symlinks
ln -s ~/dotfiles/.vimrc         ~/.vimrc
ln -s ~/dotfiles/.tmux.conf 	~/.tmux.conf
ln -s ~/dotfiles/.ssh/config    ~/.ssh/config
ln -s ~/dotfiles/.inputrc       ~/.inputrc
rm ~/.bashrc
ln -s ~/dotfiles/.bashrc		~/.bashrc

echo Configuring git
git config --global credential.helper cache 3600
git config --global core.editor "vim"
git config --global user.name "van"
git config --global user.email "-"

echo Setting up VIM
echo Installing latest VIM from source
git clone git@github.com:vim/vim ~/vim
cd ~/vim/src
sudo apt install -y libncurses5-dev
make distclean  # clear previous install if any
make
sudo make install
sudo mv ~/vim/src/vim /usr/bin
echo Clearning up
sudo rm -rf ~/vim
sudo apt purge -y vim
sudo apt autoremove -y
which vim
vim --version
echo Cloning .vim plugins
mkdir -p ~/.vim/pack/bundle/start
cd ~/.vim/pack/bundle/start
git clone git@github.com:airblade/vim-gitgutter
git clone git@github.com:itchyny/lightline.vim

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

echo 'Done. Remember to source .bashrc, exec bash -l, and gcloud init (if this is the first time run)'
