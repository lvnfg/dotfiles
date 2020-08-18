#!/bin/bash

# common setup for all GNU debian linux VMs

echo Installing apps
sudo apt install -y tmux
sudo apt install -y fzf
sudo apt install -y git

echo Creating symlinks
rm      ~/.bashrc
mkdir   ~/.config/nvim
ln -s ~/dotfiles/.bashrc		~/.bashrc
ln -s ~/dotfiles/.inputrc       ~/.inputrc
ln -s ~/dotfiles/.ssh/config    ~/.ssh/config
ln -s ~/dotfiles/.tmux.conf 	~/.tmux.conf
ln -s ~/dotfiles/init.vim       ~/.config/nvim/
ln -s ~/dotfiles/.vimrc         ~/.vimrc

echo Configuring git
git config --global credential.helper cache 3600
git config --global core.editor "vim"
git config --global user.name "van"
git config --global user.email "-"

echo Installing neovim
sudo apt install -y neovim
echo Installing plug.vim
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
echo Purging pre-installed vim
sudo apt purge -y vim
sudo apt autoremove -y

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
