#!/bin/bash
set -euox pipefail

script_name=$0
path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Stup git
git config --global core.editor     "code"
git config --global user.name       "van"
git config --global user.email      "-"

# Install neovim
brew install neovim

# install vim-plug
echo "installing vim plug"
# curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# symlink nvim config
echo "creating neovim config symlinks"
wdir="$HOME/.config/nvim" && mkdir -pv $wdir
ln -s -f ~/repos/dotfiles/init.vim $wdir/init.vim
