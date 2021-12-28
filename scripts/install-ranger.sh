#!/bin/bash

sudo apt install ranger
# Symlink ranger config
mkdir ~/.config/ranger
ln -s -f $DOTFILES/rc.conf	    ~/.config/ranger/rc.conf
ln -s -f $DOTFILES/scope.sh	    ~/.config/ranger/scope.sh
# Make scope.sh executable for ranger
chmod +x $DOTFILES/scope.sh

# ---------------------------------------------
# This script is only needed because rnvimr plugin requires Ranger 1.9.3
# above, while only 1.9.2 is available for Debian stable as of 2021-08-15.
# Ranger built from source has permission error when calling preview script,
# so preview will not work.
#
# Install using pip3 whenever a newer version is available.

# cd ~
# git clone https://github.com/ranger/ranger ~/.ranger
# cd ~/.ranger
# sudo make install

# If Ranger has previously been installed via pip, launching Ranger
# may throw an errro /usr/bin/ranger: No such file or directory. This
# is because the older paths are hashes by bash. Remove all hash entries
# using the command below will fix the problem.

# hash -r
