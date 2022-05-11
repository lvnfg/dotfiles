#!/bin/bash
set -euo pipefail

path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ln -s -f $path/.bashrc       ~/.bashrc
ln -s -f $path/.inputrc      ~/.inputrc
ln -s -f $path/.bash_profile ~/.bash_profile
# ln -s -f $path/bash/.bashrc     ~/.profile       # .profile is reserved for env var, do not use
