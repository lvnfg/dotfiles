#!/bin/bash
set -euo pipefail

path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# remove preinstalled neovim if any
echo "removing neovim"
apt remove neovim -y
rm -f /usr/bin/nvim

# Download package
cd $HOME
filename="nvim.deb"
wget https://github.com/neovim/neovim/releases/download/v0.7.0/nvim-linux64.deb -O $filename
apt install "./$filename" -y
rm $filename
# Note: package must be removed by name = neovim and not nvim

# Create neovim symlink. Must use /usr/local/bin for macos compatibility
echo "creating neovim symlink"
ln -s -f $HOME/neovim-nightly/usr/bin/nvim  /usr/local/bin/nvim

# symlink nvim config
echo "creating neovim config symlinks"
wdir="$HOME/.config/nvim" && mkdir -pv $wdir
# ln -s -f $path/init.vim $wdir/init.vim
# ln -s -f $path/.vimrc $HOME/.vimrc
echo wdir: "$wdir"
echo path: "$path"
ln -s -f $path/init.lua $wdir/init.lua
ln -s -f $path/lua $wdir
ln -s -f $path/coc-settings.json $HOME/.config/nvim/coc-settings.json

# Install Paq package manage
echo "Cloning paq-nvim"
PAQDIR="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/pack/paqs/start/paq-nvim"
if [ ! -d $PAQDIR ]; then
    echo cloning to "$PAQDIR"
    git clone --depth=1 https://github.com/savq/paq-nvim.git "$PAQDIR"
else
    echo "Paq-nvim already exists. Pulling update."
    cd $PAQDIR
    git pull
fi
cd $path

# Install plugins with Paq-nvim
nvim --headless +'PaqInstall' +qa   # +qa = send qa key to exit confirmation dialog

# Install treesitter languages
# https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
nvim --headless +'TSInstall python bash lua' +qa

# Pynvim for nvim's python plugins
# pip3 install pynvim

# For mac
# brew install neovim

echo "neovim ✅"
