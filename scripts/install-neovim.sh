#!/bin/bash

cd ~
wget --no-check-certificate --content-disposition https://github.com/neovim/neovim/releases/download/stable/nvim.appimage
chmod u+x nvim.appimage && ./nvim.appimage --appimage-extract
rm nvim.appimage && rm -rf ~/neovim-nightly
mv squashfs-root ~/neovim-nightly

# remove preinstalled neovim if any
echo "removing neovim"
sudo apt remove neovim
sudo rm -f /usr/bin/nvim

# Must use /usr/local/bin for macos compatibility
echo "creating neovim symlink"
sudo ln -s -f ~/neovim-nightly/usr/bin/nvim  /usr/local/bin/nvim

# install vim-plug
echo "installing vim plug"
# curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# symlink nvim config
echo "creating neovim config symlinks"
wdir="$HOME/.config/nvim" && mkdir -pv $wdir
ln -s -f $DOTFILES/init.vim $wdir/init.vim
ln -s -f ~/repos/dotfiles/coc-settings.json ~/.config/nvim/coc-settings.json
