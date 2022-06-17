#!/bin/bash
set -euox pipefail
path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ "$EUID" -ne 0 ]; then issudo="sudo"; else issudo=""; fi

# Install ranger
$issudo apt-get install ranger -y
# Symlink ranger config
rm -rf $HOME/.config/ranger
mkdir -p $HOME/.config/ranger
ln -s -f $path/ranger/rc.conf	   $HOME/.config/ranger/rc.conf
ln -s -f $path/ranger/commands.py  $HOME/.config/ranger/commands.py

# enable scope.sh to preview more file types such as images, xls, pdf, html etc
chmod +x $path/ranger/scope.sh    # Make scope.sh executable to enable preview
ln -s -f $path/ranger/scope.sh $HOME/.config/ranger/scope.sh

# Install devicons
# echo "Install ranger devicons"
# REPODIR="$HOME/.config/ranger/plugins/ranger_devicons"
# if [ ! -d $REPODIR ]; then
#     echo cloning to "$REPODIR"
#     git clone https://github.com/alexanderjeurissen/ranger_devicons $REPODIR
# else
#     echo "Paq-nvim already exists. Pulling update."
#     cd $REPODIR
#     git pull
# fi
# cd $path
