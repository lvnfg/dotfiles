#!/bin/bash
set -euox pipefail

rm -rf $HOME/.fzf
git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
$HOME/.fzf/install
ln -s -f $HOME/.fzf/bin/fzf  /usr/local/bin/fzf
