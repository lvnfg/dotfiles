#!/bin/bash
set -euox pipefail
path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ "$EUID" -ne 0 ]; then issudo="sudo"; else issudo=""; fi

# remove preinstalled neovim if any
echo "removing neovim"
$issudo apt-get remove neovim -y
rm -f /usr/bin/nvim

# Download package
cd $HOME
filename="nvim.deb"
wget https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.deb -O $filename
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
git clone https://github.com/junegunn/fzf                --depth 1 || true
git clone https://github.com/junegunn/fzf.vim            --depth 1 || true
git clone https://github.com/lvnfg/vim-gitgutter         --depth 1 || true
git clone https://github.com/lvnfg/vim-easy-align        --depth 1 || true
# ----------------------------------------------------------------------------
# colorschemes
# ----------------------------------------------------------------------------
# git clone https://github.com/catppuccin/nvim               --depth 1 || true  # as 'catppucine'
# git clone https://github.com/srcery-colors/srcery-vim      --depth 1 || true  # as = 'srcery'
# git clone https://rigel.netlify.app/#vim                   --depth 1 || true
# git clone https://github.com/andreypopp/vim-colors-plain   --depth 1 || true
# git clone https://github.com/ful1e5/onedark.nvim           --depth 1 || true
# git clone https://github.com/EdenEast/nightfox.nvim        --depth 1 || true
# git clone https://github.com/Mofiqul/dracula.nvim          --depth 1 || true
# git clone https://github.com/sainnhe/everforest            --depth 1 || true
# git clone https://github.com/folke/tokyonight.nvim         --depth 1 || true
# git clone https://github.com/sainnhe/gruvbox-material      --depth 1 || true
# git clone https://github.com/sainnhe/edge                  --depth 1 || true
  git clone https://github.com/lvnfg/sonokai                 --depth 1 || true
# git clone https://github.com/bluz71/vim-nightfly-guicolors --depth 1 || true
# git clone https://github.com/mhartington/oceanic-next      --depth 1 || true
# git clone https://github.com/fenetikm/falcon               --depth 1 || true
# git clone https://github.com/marko-cerovac/material.nvim   --depth 1 || true
# git clone https://github.com/shaunsingh/nord.nvim          --depth 1 || true
# git clone https://github.com/rebelot/kanagawa.nvim         --depth 1 || true
# git clone https://github.com/navarasu/onedark.nvim         --depth 1 || true
# git clone https://github.com/olimorris/onedarkpro.nvim     --depth 1 || true
# git clone https://github.com/mcchrish/zenbones.nvim        --depth 1 || true
# git clone https://pineapplegiant.github.io/spaceduck       --depth 1 || true
# git clone https://github.com/luisiacc/gruvbox-baby         --depth 1 || true
# ----------------------------------------------------------------------------
# nvim-treesitter
# Require apt install build-essential to build language parsers (vim, lua, python...)
# ----------------------------------------------------------------------------
git clone https://github.com/nvim-treesitter/nvim-treesitter --depth 1 || true
# ----------------------------------------------------------------------------
# nvim-lspconfig + fzf-lsp
# ----------------------------------------------------------------------------
git clone https://github.com/neovim/nvim-lspconfig --depth 1 || true
git clone https://github.com/lvnfg/fzf-lsp.nvim    --depth 1 || true
# ----------------------------------------------------------------------------
# nvim-cmp & autocompletion plugins
# ----------------------------------------------------------------------------
git clone https://github.com/lvnfg/cmp-nvim-lsp --depth 1 || true
git clone https://github.com/lvnfg/cmp-buffer   --depth 1 || true
git clone https://github.com/lvnfg/cmp-path     --depth 1 || true
git clone https://github.com/lvnfg/cmp-cmdline  --depth 1 || true
git clone https://github.com/lvnfg/nvim-cmp     --depth 1 || true
git clone https://github.com/lvnfg/cmp-vsnip    --depth 1 || true
git clone https://github.com/lvnfg/vim-vsnip    --depth 1 || true
