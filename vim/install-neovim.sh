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

# symlink nvim config
echo "creating neovim config symlinks"
wdir="$HOME/.config/nvim" && mkdir -pv $wdir
ln -s -f $DOTFILES/vim/init.vim $wdir/init.vim
# ln -s -f $DOTFILES/init.lua $wdir/init.lua
ln -s -f $DOTFILES/vim/coc-settings.json ~/.config/nvim/coc-settings.json

# Pynvim for nvim's python plugins
# pip3 install pynvim

# Node js if using nvim as IDE
# bash "$path/install-nodejs.sh"

# For mac
# brew install neovim
