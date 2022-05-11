#!/bin/bash
set -euo pipefail

rm -rf ~/.fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
sudo ln -s -f ~/.fzf/bin/fzf  /usr/local/bin/fzf
