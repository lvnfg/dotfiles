#!/bin/bash
set -euox pipefail
path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ "$EUID" -ne 0 ]; then issudo="sudo"; else issudo=""; fi

# symlink nvim config
echo "creating neovim config symlinks"
wdir="$HOME/.config/nvim" && mkdir -pv $wdir
# ln -s -f $path/vim/init.vim $wdir/init.vim
# ln -s -f $path/vim/.vimrc $HOME/.vimrc
ln -s -f $path/vim/init.lua $wdir/init.lua
ln -s -f $path/vim/lua $wdir
ln -s -f $path/vim/coc-settings.json $HOME/.config/nvim/coc-settings.json

echo "Installing nvim plugins"
PLUGDIR="$HOME/.local/share/nvim/site/pack/plugins/start"
mkdir -p $PLUGDIR
cd $PLUGDIR
# ----------------------------------------------------------------------------
# core plugins
# ----------------------------------------------------------------------------
git clone https://github.com/lvnfg/fzf            --depth 1 || true
git clone https://github.com/lvnfg/fzf.vim        --depth 1 || true
git clone https://github.com/lvnfg/vim-gitgutter  --depth 1 || true
git clone https://github.com/lvnfg/vim-easy-align --depth 1 || true
