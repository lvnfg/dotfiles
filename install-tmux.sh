#!/bin/bash
set -euox pipefail
path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ "$EUID" -ne 0 ]; then issudo="sudo"; else issudo=""; fi

ln -s -f "$path/tmux/.tmux.conf" $HOME/.tmux.conf

# Install script for tmux
# The needed version is 3.2 for floating window.
$issudo apt-get install tmux/bullseye-backports -y
# Use this when the apt package is 3.2
# sudo apt install tmux -y
