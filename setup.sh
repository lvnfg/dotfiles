#!/bin/bash

echo Installing apps
sudo apt install -y tmux
sudo apt install -y fzf
sudo apt install -y wget
sudo apt install -y unzip
sudo apt install -y git

echo Cloning dotfiles
ssh-keyscan -H github.com >> ~/.ssh/known_hosts
git clone git@github.com:lvnfg/dotfiles		~/dotfiles
echo Configuring git
git config --global core.editor "vim"
git config --global user.name "van"
git config --global user.email "-"

echo Creating symlinks
rm      	~/.bashrc
mkdir -p	~/.config/nvim
ln -s ~/dotfiles/.bashrc		~/.bashrc
ln -s ~/dotfiles/.inputrc		~/.inputrc
ln -s ~/dotfiles/.ssh/config	~/.ssh/config
ln -s ~/dotfiles/.tmux.conf		~/.tmux.conf
ln -s ~/dotfiles/init.vim		~/.config/nvim/
ln -s ~/dotfiles/.vimrc			~/.vimrc


echo Installing neovim
sudo apt install -y fuse
wget https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
chmod u+x nvim.appimage
sudo mv nvim.appimage /usr/bin/
sudo apt purge -y vim
sudo apt autoremove -y
echo Setting nvim as default and alternatives
nvimPath="/usr/bin/nvim.appimage"
set -u
sudo update-alternatives --install /usr/bin/ex		ex			"$nvimPath" 110
sudo update-alternatives --install /usr/bin/vi		vi			"$nvimPath" 110
sudo update-alternatives --install /usr/bin/view	view		"$nvimPath" 110
sudo update-alternatives --install /usr/bin/vim		vim			"$nvimPath" 110
sudo update-alternatives --install /usr/bin/vimdiff vim diff	"$nvimPath" 110
echo Installing plug.vim
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
nvim +PlugInstall +qall

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
