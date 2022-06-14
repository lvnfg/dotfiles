#!/bin/bash
set -euo pipefail

path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p $HOME/.config/procps
ln -s -f $path/toprc $HOME/.config/procps/toprc

echo "---------------------------------------"
echo "TOP INSTALL SUCCESSFUL"
echo "---------------------------------------"
