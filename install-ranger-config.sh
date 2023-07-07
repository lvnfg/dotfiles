#!/bin/bash
set -euox pipefail
path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ "$EUID" -ne 0 ]; then issudo="sudo"; else issudo=""; fi

# Remove ranger config directory. Everything is directly patched
# to source code
rm -rf "$HOME/.config/ranger"

# Patch ranger source code to enable functionalities without relying on custom .config
# which doesn't work inside docker container.
SOURCE="/usr/lib/python3/dist-packages/ranger"
$issudo ln -s -f $path/ranger/rc.conf $SOURCE/config/rc.conf
$issudo ln -s -f $path/ranger/commands.py $SOURCE/config/commands.py
$issudo ln -s -f $path/ranger/rifle.conf $SOURCE/config/rifle.conf  # Editor type
if [ "$issudo" != "sudo" ]; then
    # Patch ranger to enable file preview as root
    ln -s -f $path/ranger/main.py $SOURCE/core/main.py
fi

# Threre is no need to enable scope.sh in docker or terminal only environemnt. No way
# to preview images, files, pdf, xlsx, html render etc.

# Devicons can't be displayed inside docker container.
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
