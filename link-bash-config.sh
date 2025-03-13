#!/bin/bash
set -euox pipefail
path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ln -s -f $path/bash/.bashrc       $HOME/.bashrc
ln -s -f $path/bash/.inputrc      $HOME/.inputrc
ln -s -f $path/bash/.bash_profile $HOME/.bash_profile
# ln -s -f $path/bash/.bashrc     $HOME/.profile       # .profile is reserved for env var, do not use
