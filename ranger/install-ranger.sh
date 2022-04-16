#!/bin/bash

path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Symlink ranger config
mkdir ~/.config/ranger
ln -s -f $path/rc.conf	    ~/.config/ranger/rc.conf
ln -s -f $path/scope.sh	    ~/.config/ranger/scope.sh
# Make scope.sh executable for ranger
chmod +x $path/ranger/scope.sh
sudo apt install ranger -y

# Install devicons
git clone https://github.com/alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons
