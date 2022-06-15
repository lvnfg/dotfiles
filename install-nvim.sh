#!/bin/bash
set -euo pipefail
echo 🚸 $0
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
# ln -s -f $path/vim/init.vim $wdir/init.vim
# ln -s -f $path/vim/.vimrc $HOME/.vimrc
ln -s -f $path/vim/init.lua $wdir/init.lua
ln -s -f $path/vim/lua $wdir
ln -s -f $path/vim/coc-settings.json $HOME/.config/nvim/coc-settings.json

# symlink nvim plugins directory
PLUGDIR="$HOME/.local/share/nvim/site/pack/plugins"
mkdir -p $PLUGDIR
ln -s -f $path/vim/plugins $PLUGDIR/start

echo "✅ $0"
