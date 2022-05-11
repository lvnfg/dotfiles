#!/bin/bash
set -euo pipefail

pip3 install litecli
mkdir -p ~/.config/litecli
ln -s -f $DOTFILES/litecli/config ~/.config/litecli/config
