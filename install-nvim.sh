#!/bin/bash
echo 🚸 $0
set -euo pipefail
path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ "$EUID" -ne 0 ]; then issudo="sudo"; else issudo=""; fi

# remove preinstalled neovim if any
echo "removing neovim"
$issudo apt-get remove neovim -y
rm -f /usr/bin/nvim

# Download package
cd $HOME
filename="nvim.deb"
wget https://github.com/neovim/neovim/releases/download/v0.7.0/nvim-linux64.deb -O $filename
$issudo apt-get install "./$filename" -y
rm $filename
# Note: package must be removed by name = neovim and not nvim

# Create neovim symlink. Must use /usr/local/bin for macos compatibility
echo "creating neovim symlink"
$issudo ln -s -f $HOME/neovim-nightly/usr/bin/nvim  /usr/local/bin/nvim

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
git clone https://github.com/junegunn/fzf                || true
git clone https://github.com/junegunn/fzf.vim            || true
git clone https://github.com/lvnfg/vim-better-whitespace || true
git clone https://github.com/lvnfg/vim-tmux-navigator    || true
git clone https://github.com/lvnfg/vim-gitgutter         || true
git clone https://github.com/lvnfg/vim-easy-align        || true
# ----------------------------------------------------------------------------
# colorschemes
# ----------------------------------------------------------------------------
# git clone https://github.com/catppuccin/nvim               || true  # as 'catppucine'
# git clone https://github.com/srcery-colors/srcery-vim      || true  # as = 'srcery'
# git clone https://rigel.netlify.app/#vim                   || true
# git clone https://github.com/andreypopp/vim-colors-plain   || true
# git clone https://github.com/ful1e5/onedark.nvim           || true
# git clone https://github.com/EdenEast/nightfox.nvim        || true
# git clone https://github.com/Mofiqul/dracula.nvim          || true
# git clone https://github.com/sainnhe/everforest            || true
# git clone https://github.com/folke/tokyonight.nvim         || true
# git clone https://github.com/sainnhe/gruvbox-material      || true
# git clone https://github.com/sainnhe/edge                  || true
  git clone https://github.com/lvnfg/sonokai                 || true
# git clone https://github.com/bluz71/vim-nightfly-guicolors || true
# git clone https://github.com/mhartington/oceanic-next      || true
# git clone https://github.com/fenetikm/falcon               || true
# git clone https://github.com/marko-cerovac/material.nvim   || true
# git clone https://github.com/shaunsingh/nord.nvim          || true
# git clone https://github.com/rebelot/kanagawa.nvim         || true
# git clone https://github.com/navarasu/onedark.nvim         || true
# git clone https://github.com/olimorris/onedarkpro.nvim     || true
# git clone https://github.com/mcchrish/zenbones.nvim        || true
# git clone https://pineapplegiant.github.io/spaceduck       || true
# git clone https://github.com/luisiacc/gruvbox-baby         || true
# ----------------------------------------------------------------------------
# nvim-treesitter
# ----------------------------------------------------------------------------
git clone https://github.com/nvim-treesitter/nvim-treesitter || true        # Require apt install build-essential
# Supported languages: https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
nvim --headless +"TSInstall python bash lua" +'sleep 20' +'qa'
# ----------------------------------------------------------------------------
# nvim-lspconfig + fzf-lsp
# ----------------------------------------------------------------------------
git clone https://github.com/neovim/nvim-lspconfig || true
git clone https://github.com/lvnfg/fzf-lsp.nvim    || true
# ----------------------------------------------------------------------------
# nvim-cmp & autocompletion plugins
# ----------------------------------------------------------------------------
git clone https://github.com/hrsh7th/cmp-nvim-lsp || true
git clone https://github.com/hrsh7th/cmp-buffer   || true
git clone https://github.com/hrsh7th/cmp-path     || true
git clone https://github.com/hrsh7th/cmp-cmdline  || true
git clone https://github.com/hrsh7th/nvim-cmp     || true
git clone https://github.com/hrsh7th/cmp-vsnip    || true
git clone https://github.com/hrsh7th/vim-vsnip    || true

echo "✅ $0"
