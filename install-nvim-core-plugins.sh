#!/bin/bash
echo 🚸 $0
set -euo pipefail
path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Install core plugins
mkdir -p "$path/vim/plugins"    # in .gitignore so not guaranteed to exists
cd "$path/vim/plugins"
# FZF
git clone https://github.com/junegunn/fzf || true
git clone https://github.com/junegunn/fzf.vim || true
# Better whitepsace
git clone https://github.com/ntpeters/vim-better-whitespace || true
# Tmux navigator
git clone https://github.com/lvnfg/vim-tmux-navigator || true
# Git gutter
git clone https://github.com/lvnfg/vim-gitgutter || true
# Easy align
git clone https://github.com/lvnfg/vim-easy-align || true
# g.easy_align_ignore_groups = '[]'  -- [] = Align everything, including strings and comments.
# C-g to cycle through options interactively.
# ---------------------------------------------
# Color schemes
# ---------------------------------------------
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
  git clone https://github.com/sainnhe/sonokai               || true
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

echo "✅ $0"
