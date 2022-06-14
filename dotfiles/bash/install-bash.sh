#!/bin/bash
set -euo pipefail

path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ln -s -f $path/.bashrc       $HOME/.bashrc
ln -s -f $path/.inputrc      $HOME/.inputrc
ln -s -f $path/.bash_profile $HOME/.bash_profile
# ln -s -f $path/bash/.bashrc     $HOME/.profile       # .profile is reserved for env var, do not use

echo "-------------------------------------"
echo "BASH INSTALL SUCCESFUL"
echo "-------------------------------------"
