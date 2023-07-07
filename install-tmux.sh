#!/bin/bash
set -euox pipefail
path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ "$EUID" -ne 0 ]; then issudo="sudo"; else issudo=""; fi

ln -s -f "$path/tmux/.tmux.conf" $HOME/.tmux.conf

# Install script for tmux
# The needed version is 3.2 for floating window.

# Check Debian version
DEBIAN_VER="$(cat /etc/debian_version)"
if [ "$DEBIAN_VER" = "12.0" ];
then 
  # For Debian 12, install directly from repo
  $issudo apt install tmux -y
else 
  # For Debian 11, needs backports kernel
  $issudo apt-get install tmux/bullseye-backports -y
fi
