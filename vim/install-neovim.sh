#!/bin/bash
set -euo pipefail

path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# remove preinstalled neovim if any
echo "removing neovim"
sudo apt remove neovim
sudo rm -f /usr/bin/nvim

# Download package
cd ~
filename="nvim.deb"
wget https://github.com/neovim/neovim/releases/download/v0.7.0/nvim-linux64.deb -O $filename
sudo apt install "./$filename"
rm $filename

# Create neovim symlink. Must use /usr/local/bin for macos compatibility
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
