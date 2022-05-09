#!/bin/bash

path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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
# ln -s -f $path/init.vim $wdir/init.vim
# ln -s -f $path/.vimrc ~/.vimrc
ln -s -f $path/init.lua $wdir/init.lua
ln -s -f $path/lua $wdir/lua
ln -s -f $path/coc-settings.json ~/.config/nvim/coc-settings.json

# Install Paq package manager
git clone --depth=1 https://github.com/savq/paq-nvim.git "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/paqs/start/paq-nvim

# Pynvim for nvim's python plugins
# pip3 install pynvim

# For mac
# brew install neovim
