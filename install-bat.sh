#!/bin/bash
set -euo pipefail

apt-get install -y bat
mkdir -p $HOME/.local/bin
ln -s -f /usr/bin/batcat $HOME/.local/bin/bat

echo "bat ✅"
